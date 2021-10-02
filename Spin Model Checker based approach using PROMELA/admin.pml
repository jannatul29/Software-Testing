mtype = { login_req, login_pg, login_info, prof_pg, teacher_list_req, teacher_list, student_list_req, student_list, field_req, add_or_remove_field, updated_field, select_field, subject_list, add_subject, updated_subject_list, remove_subject, dashboard_req, dashboard, feedback_req, feedback, logout_req, destroy_session};
chan to_user = [3] of { mtype };
chan to_system = [5] of { mtype };
active proctype User()
{ bit invalid, empty_f;
start:
      atomic {
	   invalid	= 0;
                   empty_f  = 0;
	   goto again
	};
again: 
to_system!login_req;
to_user?login_pg;
s1: to_system!login_info;
if
::(!invalid)-> to_user?prof_pg;
	    to_system!teacher_list_req;
                    to_user?teacher_list;
	    to_system!student_list_req;
                    to_user?student_list;
                    to_system!field_req;
              s2: to_system!add_or_remove_field;
                    to_user? updated_field;
                    to_system!select_field;
                     if
                     ::(!empty_f)-> to_user?subject_list; 
                                         to_system!add_subject;
                                         to_user?updated_subject_list;  
                                         to_system!remove_subject;
                                         to_user?updated_subject_list;  
                     :: (empty_f) ->
                                          goto s2
                      fi;
                      to_system! dashboard_req;
                      to_user? dashboard; 
                      to_system! feedback_req;
                      to_user? feedback;
                      to_system! logout_req;
                      to_user? destroy_session;
   
:: (invalid) ->
    goto s1
fi;
 goto again
}
active proctype System()
{ bit invalid, empty_f;
start:
      atomic {
	   invalid	= 0;
                   empty_f  = 0;
	   goto again
	};
again: 
to_system?login_req;
to_user!login_pg;
s1: to_system?login_info;
if
::(!invalid)-> to_user!prof_pg;
	    to_system?teacher_list_req;
                    to_user!teacher_list;
	    to_system?student_list_req;
                    to_user!student_list;
                    to_system?field_req;
              s2: to_system?add_or_remove_field;
                    to_user! updated_field;
                    to_system?select_field;
                     if
                     ::(!empty_f)-> to_user!subject_list; 
                                         to_system?add_subject;
                                         to_user!updated_subject_list;  
                                         to_system?remove_subject;
                                         to_user!updated_subject_list;  
                     :: (empty_f) ->
                                          goto s2
                      fi;
                      to_system? dashboard_req;
                      to_user! dashboard; 
                      to_system? feedback_req;
                      to_user! feedback;
                      to_system? logout_req;
                      to_user! destroy_session;
   
:: (invalid) ->
    goto s1
fi;
 goto again

}

