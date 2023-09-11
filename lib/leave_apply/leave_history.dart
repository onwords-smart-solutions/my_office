import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/leave_history_model.dart';

class LeaveHistory extends StatelessWidget {
  final List<LeaveHistoryModel> history;

  const LeaveHistory({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    history.sort((a,b)=>b.date.compareTo(a.date));
    return history.isEmpty
        ? const Center(
            child: Text(
              'No leave history found',
              style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 20.0),
            ),
          )
        : ListView.builder(
            itemCount: history.length,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemBuilder: (ctx, index) {


              String status = 'Not mentioned';
              Color color = Colors.grey;
              if (history[index].status.toLowerCase() == 'declined') {
                color = Colors.red;
                status = 'Declined';
              } else if (history[index].status.toLowerCase() == 'pending') {
                color = Colors.orange;
                status = 'Pending';
              } else if (history[index].status.toLowerCase() == 'approved') {
                color = Colors.green;
                status = 'Approved';
              }

              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(history[index].date),
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * .09,
                            child: Text(
                              history[index].reason,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              status,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                              ),
                            ),
                            if(history[index].updatedBy.isNotEmpty)
                              Text(
                               '(${history[index].updatedBy})',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                ),
                              )
                          ],
                        ),
                        Container(
                          width: 30.0,
                          height: MediaQuery.sizeOf(context).height * .12,
                          margin: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            });
  }

  String _formatDate(DateTime date) => DateFormat.yMMMEd().format(date);
}
