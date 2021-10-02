mtype = { crt_acc_req, snd_acc_pg, entr_acc_info, login_req, login_info, prof_pg, prof_edit, profedit_pg, prof_edit_data, update_prof, pass_rcvy_req,  pass_rcvy_pg, rcvy_data, feedback_req, feedback_pg, feedback_data, successful, logout_req, destroy_session};
chan to_user = [3] of { mtype };
chan to_system = [5] of { mtype };
active proctype User()
{ bit invalid, logged, feedback, logout;
short recovery;
start:
      atomic {
	   invalid	= 0;
                   logged  = 1;
                   feedback = 1;
                   logout = 1;
                   recovery = 1;
	   goto again
	};
s5:
  atomic {
                   recovery = recovery+1;
	   goto s6
	};
again: to_system!crt_acc_req;
 to_user?snd_acc_pg;
s1:  to_system!entr_acc_info;
if
::(!invalid)-> to_user?login_req;
               s2: to_system!login_info;
                     if
                     ::(!invalid)-> to_user?prof_pg;
	                         to_system!prof_edit;
                                         to_user?profedit_pg;
                                         to_system!prof_edit_data;
                                         to_user?update_prof;
                                         if
                                       ::(recovery != 1 ) -> 
			                       goto s4;
                                       ::(recovery == 1)->  
                                                              to_system! pass_rcvy_req;
                                                                 to_user? pass_rcvy_pg;
                                                           s3: to_system! rcvy_data;
                                                                 if
                                                                 ::(!invalid)-> 
                                                                                    to_user?login_req;
                                                                                    	goto s5;
	                                                              s6:  goto s2; 
                                                                 :: (invalid) ->
                                                                                      goto s3
                                                                 fi;
                                         fi; 
                                         s4:
                                         if
                                        ::(feedback)-> to_system! feedback_req;
                                                                to_user? feedback_pg;
                                                                to_system! feedback_data;
                                                                if
                                                                ::(logged)-> to_user?successful;
                                                                ::(!logged)-> to_user?login_req; 
                                                                                     goto s2;
                                                                 fi;
                                           fi; 
                                           if 
                                           ::(logout)->to_system! logout_req;
                                                             to_user? destroy_session;
                                           fi;	
                    :: (invalid) ->
                         goto s1	
                      fi;	
:: (invalid) ->
    goto s1
fi;
 
 goto again
}
active proctype System()
{ bit invalid, logged, feedback, logout;
short recovery;
start:
      atomic {
	   invalid	= 0;
                   logged  = 1;
                   feedback = 1;
                   logout = 1;
                   recovery = 1;
	   goto again
	};
s5:
  atomic {
                   recovery = recovery+1;
	   goto s6
	};
again: to_system?crt_acc_req;
 to_user!snd_acc_pg;
s1:  to_system?entr_acc_info;
if
::(!invalid)-> to_user!login_req;
               s2: to_system?login_info;
                     if
                     ::(!invalid)-> to_user!prof_pg;
	                         to_system?prof_edit;
                                         to_user!profedit_pg;
                                         to_system?prof_edit_data;
                                         to_user!update_prof;
                                         if
                                         ::(recovery != 1 ) -> 
			                  goto s4
                                         ::(recovery == 1)->
                                                                to_system? pass_rcvy_req;
                                                                 to_user! pass_rcvy_pg;
                                                           s3: to_system? rcvy_data;
                                                                 if
                                                                 ::(!invalid)-> 
                                                                                    to_user!login_req;
                                                                                     goto s5;
	                                                              s6:  goto s2; 
                                                                 :: (invalid) ->
                                                                                      goto s3
                                                                 fi;
                                         fi;
                                         s4:
                                         if
                                        ::(feedback)-> to_system? feedback_req;
                                                                to_user! feedback_pg;
                                                                to_system? feedback_data;
                                                                if
                                                                ::(logged)-> to_user!successful;
                                                                ::(!logged)-> to_user!login_req; 
                                                                                     goto s2;
                                                                 fi;
                                           fi; 
                                           if 
                                           ::(logout)->to_system? logout_req;
                                                             to_user! destroy_session;
                                           fi;	
                    :: (invalid) ->
                         goto s1	
                      fi;	
:: (invalid) ->
    goto s1
fi;
 
 goto again
}



