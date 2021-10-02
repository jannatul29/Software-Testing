mtype = { field_select, subject_list, enroll_req, payment_pg, entr_payment_info, confirmed_mail, meeting_join_req, meeting_pg, rating_req, entr_rating, msg, join_meeting_sms, logout_req, destroy_session};
chan to_user = [3] of { mtype };
chan to_system = [5] of { mtype };
active proctype User()
{ bit invalid, student, teacher;
start:
      atomic {
	   invalid	= 0;
                   student  = 1;
                   teacher = 1;
	   goto again
	};
again: 
if
::(student)-> to_system! field_select;
                     to_user?subject_list;
                     to_system!enroll_req;
                     to_user?payment_pg;
               s1: to_system!entr_payment_info; 	
                     if
                     ::(!invalid)-> to_user?confirmed_mail;
                                         to_system!meeting_join_req;
                                         to_user?meeting_pg;
                                         to_user?rating_req;
                                         to_system!entr_rating;
                                         to_user?msg;                  
                      :: (invalid) ->
                                       goto s1
                       fi;
fi;
 
if
::(teacher)-> to_user?join_meeting_sms;
                     to_system!meeting_join_req;
                     to_user?meeting_pg;
fi;
to_system! logout_req;
to_user? destroy_session;
 goto again
}
active proctype System()
{ bit invalid, student, teacher;
start:
      atomic {
	   invalid	= 0;
                   student  = 1;
                   teacher = 1;
	   goto again
	};
again: 
if
::(student)-> to_system? field_select;
                     to_user!subject_list;
                     to_system?enroll_req;
                     to_user!payment_pg;
               s1: to_system?entr_payment_info; 	
                     if
                     ::(!invalid)-> to_user!confirmed_mail;
                                         to_system?meeting_join_req;
                                         to_user!meeting_pg;
                                         to_user!rating_req;
                                         to_system?entr_rating;
                                         to_user!msg;                  
                      :: (invalid) ->
                                       goto s1
                       fi;
fi;
 
if
::(teacher)-> to_user!join_meeting_sms;
                     to_system?meeting_join_req;
                     to_user!meeting_pg;
fi;
to_system? logout_req;
to_user! destroy_session;
 goto again
}


