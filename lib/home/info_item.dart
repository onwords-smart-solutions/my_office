import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../models/custom_punching_model.dart';
import '../models/staff_model.dart';

class InfoItem extends StatelessWidget {
  final StaffModel staff;
  final CustomPunchModel? staffEntryDetail;
  final List<StaffModel> todayBirthdayList;
  final DateTime endTime;
  final int quoteIndex;

  const InfoItem(
      {Key? key,
      required this.staff,
      required this.staffEntryDetail,
      required this.todayBirthdayList,
      required this.quoteIndex,
      required this.endTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final image = todayBirthdayList.isEmpty
        ? Positioned(
            right: 0,
            top: 10,
            child: Image.asset(
              // 'assets/cake.png',
              'assets/info_pic.png',
              width: size.width * .35,
              fit: BoxFit.cover,
            ))
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
          margin: EdgeInsets.symmetric(vertical: size.height * .03, horizontal: 10.0),
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
                        if (todayBirthdayList.isEmpty) _motivationSection() else _birthdaySection(size),
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
        image
      ],
    );
  }

  Widget _motivationSection() {
    final message = motivationalQuotes[quoteIndex].split('-');
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
            fontSize: 20.0,
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
                scrollDirection: Axis.horizontal,
                itemCount: todayBirthdayList.length,
                onPageChanged: (i) {
                  birthdayPageIndex.value = i;
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
                          child: todayBirthdayList[index].profilePic.isEmpty
                              ? const Image(image: AssetImage('assets/profile_icon.jpg'))
                              : CachedNetworkImage(
                                  imageUrl: todayBirthdayList[index].profilePic,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: Text(
                            'Today marks the birthday celebration of ${todayBirthdayList[index].name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          if (todayBirthdayList.length > 1)
            ValueListenableBuilder(
                valueListenable: birthdayPageIndex,
                builder: (ctx, pageIndex, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        todayBirthdayList.length,
                        (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: index == pageIndex ? Colors.white : Colors.white30,
                              ),
                            )),
                  );
                })
        ],
      ),
    );
  }

  Widget _staffEntryInfo(Size size) {
    if (staffEntryDetail == null) {
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
                  margin: const EdgeInsets.only(bottom: 5.0,left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white54
                  ),
                ),
                Container(
                  height: 8.0,
                  width: size.width * .3,
                  margin: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white54
                  ),
                )
              ],
            )),
      );
    }

    Color color = Colors.green;

    if (staffEntryDetail!.checkInTime == null) {
      color = Colors.grey;
    } else if (staffEntryDetail!.checkInTime!
                .difference(DateTime(staffEntryDetail!.checkInTime!.year, staffEntryDetail!.checkInTime!.month,
                    staffEntryDetail!.checkInTime!.day, 09, 00))
                .inMinutes >
            0 &&
        staffEntryDetail!.checkInTime!
                .difference(DateTime(staffEntryDetail!.checkInTime!.year, staffEntryDetail!.checkInTime!.month,
                    staffEntryDetail!.checkInTime!.day, 09, 10))
                .inMinutes <=
            0) {
      color = Colors.amber.shade500;
    } else if (staffEntryDetail!.checkInTime!
                .difference(DateTime(staffEntryDetail!.checkInTime!.year, staffEntryDetail!.checkInTime!.month,
                    staffEntryDetail!.checkInTime!.day, 09, 00))
                .inMinutes >
            10 &&
        staffEntryDetail!.checkInTime!
                .difference(DateTime(staffEntryDetail!.checkInTime!.year, staffEntryDetail!.checkInTime!.month,
                    staffEntryDetail!.checkInTime!.day, 09, 20))
                .inMinutes <=
            0) {
      color = Colors.orangeAccent.shade400;
    } else if (staffEntryDetail!.checkInTime!
            .difference(DateTime(staffEntryDetail!.checkInTime!.year, staffEntryDetail!.checkInTime!.month,
                staffEntryDetail!.checkInTime!.day, 09, 00))
            .inMinutes >
        20) {
      color = Colors.red.shade400;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (staffEntryDetail!.checkInTime == null)
          const Text(
            'Off the premises 😒',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 15.0),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Check-In     : ${timeFormat(staffEntryDetail!.checkInTime!)}',
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
              ),
              Text(
                'Check-Out : ${staffEntryDetail!.checkOutTime == null ? 'No entry' : timeFormat(staffEntryDetail!.checkOutTime!)}',
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
              ),
            ],
          ),
        Row(
          children: [
            if (staffEntryDetail!.checkInTime != null)
              Text(
                duration(
                  staffEntryDetail!.checkInTime!,
                  staffEntryDetail!.checkOutTime == null ? endTime : staffEntryDetail!.checkOutTime!,
                ),
                style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white70),
              ),
            Container(
              width: 5.0,
              margin: const EdgeInsets.only(left: 10.0),
              height: size.height * .05,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15.0),
              ),
            )
          ],
        )
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
  "\"The only thing that stands between you and your dream is the will to try and the belief that it is actually possible.\"",
  "\"Failure is not the opposite of success; it's part of success.\" - Deva",
  "\"The harder you work, the luckier you get.\" - Gary Player",
  "\"I can't change the direction of the wind, but I can adjust my sails to always reach my destination.\" - Jimmy Dean",
  "\"Success is walking from failure to failure with no loss of enthusiasm.\" - Winston Churchill",
  "\"Don't be pushed around by the fears in your mind. Be led by the dreams in your heart.\"",
  "\"Opportunities don't happen. You create them.\" - Chris Grosser",
  "\"Success is not the result of spontaneous combustion. You must set yourself on fire.\" - Arnold H. Glasow",
  "\"The key to success is to focus on goals, not obstacles.\" - Jibin",
  "\"The only place where success comes before work is in the dictionary.\" - Vidal Sassoon",
  "\"Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle.\" - Christian D. Larson",
  "\"Do what you love, and you'll never have to work a day in your life.\" - Confucius",
  "\"The expert in anything was once a beginner.\" - Helen Hayes",
  "\"You are the designer of your destiny; you are the author of your story.\"",
  "\"If you are not willing to risk the usual, you will have to settle for the ordinary.\" - Jim Rohn",
  "\"The journey of a thousand miles begins with a single step.\" - Lao Tzu",
];

String timeFormat(DateTime time) => DateFormat.jm().format(time);

String duration(DateTime start, DateTime end) {
  final diff = end.difference(start);
  int hours = diff.inHours;
  int minutes = diff.inMinutes % 60;

  return '${hours}h ${minutes}m';
}
