import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../user/domain/entity/user_entity.dart';
import '../view_model/custom_punch_model.dart';

class InfoItem extends StatefulWidget {
  final UserEntity staff;
  final CustomPunchModel? staffEntryDetail;
  final List<UserEntity> todayBirthdayList;
  final DateTime endTime;
  final int quoteIndex;

  const InfoItem({
    Key? key,
    required this.staff,
    required this.staffEntryDetail,
    required this.todayBirthdayList,
    required this.quoteIndex,
    required this.endTime,
  }) : super(key: key);

  @override
  State<InfoItem> createState() => _InfoItemState();
}

class _InfoItemState extends State<InfoItem> {
  final PageController _pageController = PageController();
  final PageController _prController = PageController();
  UserEntity? employeeOfTheWeek;
  String? reason = '';
  int currentIndex = 0;

  void startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (widget.todayBirthdayList.isEmpty ||
          widget.todayBirthdayList.length == 1) {
        timer.cancel();
        return;
      }
      currentIndex = (currentIndex ?? 0) + 1;
      if (currentIndex >= widget.todayBirthdayList.length) {
        currentIndex = 0;
      }

      try {
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } catch (e, s) {
        print("Error: $e");
        print("Stack trace: $s");
      }
    });
  }

  Future<void> getPrDetails() async {
    final ref = FirebaseDatabase.instance.ref();

    ref.child('PRDashboard/employee_of_week').once().then((value) async {
      if (value.snapshot.exists) {
        final data = value.snapshot.value as Map<Object?, Object?>;

        final uid = data['person'].toString();
        reason = data['reason'].toString();

        if(uid != 'null' && uid.isNotEmpty){
          await ref.child('staff/$uid').once().then((value) {
            final staffDetails = value.snapshot.value as Map<Object?, Object?>;
            try {
              employeeOfTheWeek = UserEntity(
                uid: uid,
                name: staffDetails['name'].toString(),
                dep: staffDetails['department'].toString(),
                email: staffDetails['email'].toString(),
                url: staffDetails['profileImage'].toString(),
                dob: staffDetails['dob'] == null
                    ? 0
                    : int.parse(staffDetails['dob'].toString()),
                mobile: staffDetails['mobile'] == null
                    ? 0
                    : int.parse(staffDetails['mobile'].toString()),
                uniqueId: '',
              );
            } catch (e) {
              log('Error from $e');
            }
            setState(() {});
          });
        }
      }
    });
  }

  @override
  void initState() {
    startAutoScroll();
    getPrDetails();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _prController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final image = widget.todayBirthdayList.isEmpty
        ? Positioned(
      right: 0,
      top: 10,
      child: Image.asset(
        // 'assets/cake.png',
        'assets/info_pic.png',
        width: size.width * .35,
        fit: BoxFit.cover,
      ),
    )
        : Positioned(
      right: -5,
      top: 0,
      child: Image.asset(
        'assets/cake.png',
        width: size.width * .34,
        fit: BoxFit.cover,
      ),
    );
    return Stack(
      children: [
        Container(
          width: size.width,
          margin: EdgeInsets.symmetric(
            vertical: size.height * .03,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: Offset(5, 5),
              ),
            ],
            color: Colors.deepPurple,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.white12,
                ),
                const Positioned(
                  top: -10,
                  left: -10,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white12,
                  ),
                ),
                const Positioned(
                  right: -10,
                  bottom: -10,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white12,
                  ),
                ),
                const Positioned(
                  right: -10,
                  bottom: -20,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white12,
                  ),
                ),
                SizedBox(
                  width: size.width * .65,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        if (widget.todayBirthdayList.isEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: PageView(
                              scrollDirection: Axis.horizontal,
                              controller: _prController,
                              children: [
                                if (employeeOfTheWeek != null)
                                  _prEmployeeOfTheWeek(),
                                _motivationSection(),
                              ],
                            ),
                          )
                        else
                          _birthdaySection(size),
                        const SizedBox(height: 10.0),
                        _staffEntryInfo(size),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        //image
        image,
      ],
    );
  }

  Widget _prEmployeeOfTheWeek() {
    final size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Employee of the Week',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.tealAccent,
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.width * .15,
                width: size.width * .15,
                margin: const EdgeInsets.only(right: 8.0),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  imageUrl: employeeOfTheWeek!.url,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeOfTheWeek!.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: Text(
                        reason!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _motivationSection() {
    final message = motivationalQuotes[widget.quoteIndex].split('-');
    final quote = message.first;
    final author = message.length > 1 ? message.last : '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //motivation
        Text(
          quote,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        //author
        if (author.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              ' - $author',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                fontSize: 15.0,
              ),
            ),
          ),
      ],
    );
  }

  Widget _birthdaySection(Size size) {
    final ValueNotifier<int> birthdayPageIndex = ValueNotifier(0);
    return SizedBox(
      height: size.height * .14,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              scrollBehavior: const ScrollBehavior(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.todayBirthdayList.length,
              onPageChanged: (int page) {
                currentIndex = page;
                birthdayPageIndex.value = page;
              },
              itemBuilder: (ctx, index) {
                return SizedBox(
                  width: size.width * .65,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: size.width * .2,
                        width: size.width * .2,
                        margin: const EdgeInsets.only(right: 8.0),
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: widget
                            .todayBirthdayList[index].url.isEmpty
                            ? const Image(
                          image: AssetImage('assets/profile_icon.jpg'),
                        )
                            : CachedNetworkImage(
                          imageUrl:
                          widget.todayBirthdayList[index].url,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                          errorWidget: (context, url, error) =>
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Happy Birthday ${widget.todayBirthdayList[index].name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (widget.todayBirthdayList.length > 1)
            ValueListenableBuilder(
              valueListenable: birthdayPageIndex,
              builder: (ctx, pageIndex, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.todayBirthdayList.length,
                        (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor:
                        index == pageIndex ? Colors.white : Colors.white30,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _staffEntryInfo(Size size) {
    if (widget.staffEntryDetail == null) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 8.0,
                width: size.width * .2,
                margin: const EdgeInsets.only(bottom: 5.0, left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white54,
                ),
              ),
              Container(
                height: 8.0,
                width: size.width * .3,
                margin: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Color color = Colors.green;

    if (widget.staffEntryDetail!.checkInTime == null) {
      color = Colors.grey;
    } else if (widget.staffEntryDetail!.checkInTime!
        .difference(
      DateTime(
        widget.staffEntryDetail!.checkInTime!.year,
        widget.staffEntryDetail!.checkInTime!.month,
        widget.staffEntryDetail!.checkInTime!.day,
        09,
        00,
      ),
    )
        .inMinutes >
        0 &&
        widget.staffEntryDetail!.checkInTime!
            .difference(
          DateTime(
            widget.staffEntryDetail!.checkInTime!.year,
            widget.staffEntryDetail!.checkInTime!.month,
            widget.staffEntryDetail!.checkInTime!.day,
            09,
            10,
          ),
        )
            .inMinutes <=
            0) {
      color = Colors.amber.shade500;
    } else if (widget.staffEntryDetail!.checkInTime!
        .difference(
      DateTime(
        widget.staffEntryDetail!.checkInTime!.year,
        widget.staffEntryDetail!.checkInTime!.month,
        widget.staffEntryDetail!.checkInTime!.day,
        09,
        00,
      ),
    )
        .inMinutes >
        10 &&
        widget.staffEntryDetail!.checkInTime!
            .difference(
          DateTime(
            widget.staffEntryDetail!.checkInTime!.year,
            widget.staffEntryDetail!.checkInTime!.month,
            widget.staffEntryDetail!.checkInTime!.day,
            09,
            20,
          ),
        )
            .inMinutes <=
            0) {
      color = Colors.orangeAccent.shade400;
    } else if (widget.staffEntryDetail!.checkInTime!
        .difference(
      DateTime(
        widget.staffEntryDetail!.checkInTime!.year,
        widget.staffEntryDetail!.checkInTime!.month,
        widget.staffEntryDetail!.checkInTime!.day,
        09,
        00,
      ),
    )
        .inMinutes >
        20) {
      color = Colors.red.shade400;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.staffEntryDetail!.checkInTime == null)
          const Text(
            'Off the premises 😒',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check-In     : ${timeFormat(widget.staffEntryDetail!.checkInTime!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              Text(
                'Check-Out : ${widget.staffEntryDetail!.checkOutTime == null ? 'No entry' : timeFormat(widget.staffEntryDetail!.checkOutTime!)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        Row(
          children: [
            if (widget.staffEntryDetail!.checkInTime != null)
              Text(
                duration(
                  widget.staffEntryDetail!.checkInTime!,
                  widget.staffEntryDetail!.checkOutTime == null
                      ? widget.endTime
                      : widget.staffEntryDetail!.checkOutTime!,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            Container(
              width: 5.0,
              margin: const EdgeInsets.only(left: 10.0),
              height: size.height * .05,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

List<String> motivationalQuotes = [
  "\"Success is not the key to happiness. Happiness is the key to success.\" - Albert Schweitzer",
  "\"The only way to do great work is to love what you do.\" - Steve Jobs",
  "\"In the world of technology, change is constant. Embrace it with enthusiasm.\"",
  "\"The harder you work for something, the greater you'll feel when you achieve it.\"",
  "\"Every expert was once a beginner.\"",
  "\"Success is walking from failure to failure with no loss of enthusiasm.\" - Winston Churchill",
  "\"The future depends on what you do today.\" - Mahatma Gandhi",
  "\"Chase the vision, not the money; the money will end up following you.\" - Tony Hsieh",
  "\"Don't watch the clock; do what it does. Keep going.\" - Sam Levenson",
  "\"The secret of getting ahead is getting started.\" - Mark Twain",
  "\"You don't have to be great to start, but you have to start to be great.\"",
  "\"Innovation distinguishes between a leader and a follower.\" - Steve Jobs",
  "\"The only limit to our realization of tomorrow will be our doubts of today.\" - Franklin D. Roosevelt",
  "\"Great things never come from comfort zones.\"",
  "\"Believe you can and you're halfway there.\" - Theodore Roosevelt",
  "\"Stay hungry, stay foolish.\" - Steve Jobs",
  "\"The best way to predict the future is to create it.\" - Peter Drucker",
  "\"I find that the harder I work, the more luck I seem to have.\" - Thomas Jefferson",
  "\"The road to success and the road to failure are almost exactly the same.\" - Colin R. Davis",
  "\"You are never too old to set another goal or to dream a new dream.\" - C.S. Lewis",
  "\"Continuous improvement is better than delayed perfection.\"",
  "\"The only place where success comes before work is in the dictionary.\" - Vidal Sassoon",
  "\"Don't be afraid to give up the good to go for the great.\" - John D. Rockefeller",
  "\"It does not matter how slowly you go as long as you do not stop.\" - Confucius",
  "\"Do not wait for the perfect moment, take the moment and make it perfect.\"",
  "\"Success usually comes to those who are too busy to be looking for it.\" - Henry David Thoreau",
  "\"Success is not in what you have, but who you are.\" - Bo Bennett",
  "\"If you're offered a seat on a rocket ship, don't ask what seat! Just get on.\" - Sheryl Sandberg",
  "\"Failure is not the opposite of success; it's part of success.\" - Deva",
  "\"The harder you work, the luckier you get.\" - Gary Player",
  "\"Success is walking from failure to failure with no loss of enthusiasm.\" - Winston Churchill",
  "\"Don't be pushed around by the fears in your mind. Be led by the dreams in your heart.\"",
  "\"Opportunities don't happen. You create them.\" - Chris Grosser",
  "\"The key to success is to focus on goals, not obstacles.\" - Jibin",
  "\"The only place where success comes before work is in the dictionary.\" - Vidal Sassoon",
  "\"Do what you love, and you'll never have to work a day in your life.\" - Confucius",
  "\"The expert in anything was once a beginner.\" - Helen Hayes",
  "\"You are the designer of your destiny; you are the author of your story.\"",
  "\"If you are not willing to risk the usual, you will have to settle for the ordinary.\" - Jim Rohn",
  "\"The journey of a thousand miles begins with a single step.\" - Lao Tzu",
  "\"The only way to do great work is to love what you do.\" - Steve Jobs",
  "\"Innovation distinguishes between a leader and a follower.\" - Steve Jobs",
  "\"The best way to predict the future is to invent it.\" - Alan Kay",
  "\"The most dangerous phrase in the language is, 'We've always done it this way.'\" - Grace Hopper",
  "\"I find that the harder I work, the more luck I seem to have.\" - Thomas Jefferson",
  "\"The computer was born to solve problems that did not exist before.\" - Bill Gates",
  "\"Don't watch the clock; do what it does. Keep going.\" - Sam Levenson",
  "\"The best time to plant a tree was 20 years ago. The second best time is now.\" - Chinese Proverb",
  "\"It's not that we use technology, we live technology.\" - Godfrey Reggio",
  "\"The great growling engine of change - technology.\" - Alvin Toffler",
  "\"The art challenges the technology, and the technology inspires the art.\" - John Lasseter",
  "\"The only thing that's constant is change.\" - Heraclitus",
  "\"It's not about ideas. It's about making ideas happen.\" - Scott Belsky",
];

String timeFormat(DateTime time) => DateFormat.jm().format(time);

String duration(DateTime start, DateTime end) {
  final diff = end.difference(start);
  int hours = diff.inHours;
  int minutes = diff.inMinutes % 60;

  return '${hours}h ${minutes}m';
}