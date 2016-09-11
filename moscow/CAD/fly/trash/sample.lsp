       (defun file_line (line_number /)
       (setq opened_file_to_read (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))
       (setq text_list nil)
       (while (setq temp_text (read-line opened_file_to_read))
       (setq text_list (append text_list (list temp_text)))
       )
       (close opened_file_to_read)
       (setq opened_file_to_write (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "w"))
       (setq line_counter 1)
       (foreach temp_text text_list
       	(if (= line_counter line_number)
       	(write-line changed_line opened_file_to_write)
        ); if
       	(if (/=
         line_counter line_number)
       	(write-line temp_text opened_file_to_write)
        ); if
       	(setq line_counter (+ line_counter 1))
       )
       (close opened_file_to_write)
       )

(defun fill_clr (name nc /)
(setq dx (dimx_tile name) dy (dimy_tile name))
    (start_image name)
    (fill_image 0 0 dx dy nc)
(end_image)
)

(defun change_clr (name /)
;(setq c (get_attr name "color"))
(setq dx (dimx_tile name) dy (dimy_tile name))
(setq nc (acad_colordlg 80));(cdr (assoc 62 (acad_truecolordlg (cons 62 (atoi c))))))
;(setq nc 0);(atoi (get_tile name)))

(if nc
   (progn
    (start_image name)
    (fill_image 0 0 dx dy nc)
    (setq changed_line (itoa nc))
    (file_line line_numb)
(end_image)
   ); progn
 ); if
)

(defun sample (/)
(setq file_list nil)
(setq color_list nil)
       (setq ini_file (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))

(if (< (setq dcl_id (load_dialog "sample.dcl")) 0) (exit))
(if (not (new_dialog "sample" dcl_id)) (exit))

;;;;;;;;;;;;;;; READ SETTING FROM SETTING.INI ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; trash-line GROUP
(read-line ini_file)
     (set_tile "group_1" (read-line ini_file))
     (set_tile "group_2" (read-line ini_file))
     (set_tile "group_3" (read-line ini_file))
     (set_tile "group_4" (read-line ini_file))
     (set_tile "group_5" (read-line ini_file))

;;; trash-line ACTION
(read-line ini_file)
     (set_tile "takeoff" (read-line ini_file))
     (set_tile "put_down" (read-line ini_file))

;;; trash-line CALCULATE
(read-line ini_file)
     (set_tile "max" (read-line ini_file))
     (set_tile "equal" (read-line ini_file))

;;; trash-line PARAMETERS
(read-line ini_file)
     (set_tile "day" (read-line ini_file))
     (set_tile "night" (read-line ini_file))
     (set_tile "count" (read-line ini_file))
     (set_tile "impact" (read-line ini_file))

;;; trash-line NOISE LEVEL--60
(read-line ini_file)
     (set_tile "db_60" (read-line ini_file))
    ; (set_tile "clr_60" (read-line ini_file))
;  (alert "fun")
     (fill_clr "clr_60" (atoi (read-line ini_file)))


     (set_tile "length_60" (read-line ini_file))
     (set_tile "width_60" (read-line ini_file))

;;; trash-line NOISE LEVEL--65
(read-line ini_file)
     (set_tile "db_65" (read-line ini_file))
     (fill_clr "clr_65" (atoi (read-line ini_file)))
     (set_tile "length_65" (read-line ini_file))
     (set_tile "width_65" (read-line ini_file))

;;; trash-line NOISE LEVEL--70
(read-line ini_file)
     (set_tile "db_70" (read-line ini_file))
     (fill_clr "clr_70" (atoi (read-line ini_file)))
     (set_tile "length_70" (read-line ini_file))
     (set_tile "width_70" (read-line ini_file))

;;; trash-line NOISE LEVEL--75
(read-line ini_file)
     (set_tile "db_75" (read-line ini_file))
     (fill_clr "clr_75" (atoi (read-line ini_file)))
     (set_tile "length_75" (read-line ini_file))
     (set_tile "width_75" (read-line ini_file))

;;; trash-line NOISE LEVEL--80
(read-line ini_file)
     (set_tile "db_80" (read-line ini_file))
     (fill_clr "clr_80" (atoi (read-line ini_file)))
     (set_tile "length_80" (read-line ini_file))
     (set_tile "width_80" (read-line ini_file))

;;; trash-line NOISE LEVEL--85
(read-line ini_file)
     (set_tile "db_85" (read-line ini_file))
     (fill_clr "clr_85" (atoi (read-line ini_file)))
     (set_tile "length_85" (read-line ini_file))
     (set_tile "width_85" (read-line ini_file))

;;; trash-line NOISE LEVEL--90
(read-line ini_file)
     (set_tile "db_90" (read-line ini_file))
     (fill_clr "clr_90" (atoi (read-line ini_file)))
     (set_tile "length_90" (read-line ini_file))
     (set_tile "width_90" (read-line ini_file))

;;; trash-line NOISE LEVEL--95
(read-line ini_file)
     (set_tile "db_95" (read-line ini_file))
     (fill_clr "clr_95" (atoi (read-line ini_file)))
     (set_tile "length_95" (read-line ini_file))
     (set_tile "width_95" (read-line ini_file))

;;; trash-line NOISE LEVEL--100
(read-line ini_file)
     (set_tile "db_100" (read-line ini_file))
     (fill_clr "clr_100" (atoi (read-line ini_file)))
     (set_tile "length_100" (read-line ini_file))
     (set_tile "width_100" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_1
(read-line ini_file)
     (set_tile "db_x_1" (read-line ini_file))
     (set_tile "custom_x_1" (read-line ini_file))
     (fill_clr "clr_x_1" (atoi (read-line ini_file)))
     (set_tile "length_x_1" (read-line ini_file))
     (set_tile "width_x_1" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_2
(read-line ini_file)
     (set_tile "db_x_2" (read-line ini_file))
     (set_tile "custom_x_2" (read-line ini_file))
     (fill_clr "clr_x_2" (atoi (read-line ini_file)))
     (set_tile "length_x_2" (read-line ini_file))
     (set_tile "width_x_2" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_3
(read-line ini_file)
     (set_tile "db_x_3" (read-line ini_file))
     (set_tile "custom_x_3" (read-line ini_file))
     (fill_clr "clr_x_3" (atoi (read-line ini_file)))
     (set_tile "length_x_3" (read-line ini_file))
     (set_tile "width_x_3" (read-line ini_file))

;;; trah-line MISC
(read-line ini_file)
     (set_tile "merge_vpp" (read-line ini_file))

;;;;;;;;;;;; ACTION PROCESSING ;;;;;;;;;;;;;;;;;;;;

;;; GROUP;;;
     (action_tile "group_1" "(setq changed_line \"1\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_2" "(setq changed_line \"1\")(file_line 3 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_3" "(setq changed_line \"1\")(file_line 4 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 5 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_4" "(setq changed_line \"1\")(file_line 5 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 6 )")
     (action_tile "group_5" "(setq changed_line \"1\")(file_line 6 )(setq changed_line \"0\")(file_line 2 )(setq changed_line \"0\")(file_line 3 )(setq changed_line \"0\")(file_line 4 )(setq changed_line \"0\")(file_line 5 )")
;;; ACTION ;;;
     (action_tile "takeoff" "(setq changed_line \"1\")(file_line 8 )(setq changed_line \"0\")(file_line 9 )")
     (action_tile "put_down" "(setq changed_line \"1\")(file_line 9 )(setq changed_line \"0\")(file_line 8 )")
;;; CALCULATE ;;;
     (action_tile "max" "(setq changed_line \"1\")(file_line 11 )(setq changed_line \"0\")(file_line 12 )")
     (action_tile "equal" "(setq changed_line \"1\")(file_line 12 )(setq changed_line \"0\")(file_line 11 )")
;;; PARAMETERS ;;;
     (action_tile "day" "(setq changed_line \"1\")(file_line 14 )(setq changed_line \"0\")(file_line 15 )")
     (action_tile "night" "(setq changed_line \"1\")(file_line 15 )(setq changed_line \"0\")(file_line 14 )")
     (action_tile "count" "(setq changed_line $value)(file_line 16 )")
     (action_tile "impact" "(setq changed_line $value)(file_line 17 )")
;;; NOISE LEVEL 60 ;;;
     (action_tile "db_60" "(setq changed_line $value)(file_line 19 )")
     (action_tile "clr_60" "(setq line_numb 20)(change_clr \"clr_60\")")
     (action_tile "length_60" "(setq changed_line $value)(file_line 21 )")
     (action_tile "width_60" "(setq changed_line $value)(file_line 22 )")

;;; NOISE LEVEL 65 ;;;
     (action_tile "db_65" "(setq changed_line $value)(file_line 24 )")
     (action_tile "clr_65" "(setq line_numb 25)(change_clr \"clr_65\")")
     (action_tile "length_65" "(setq changed_line $value)(file_line 26 )")
     (action_tile "width_65" "(setq changed_line $value)(file_line 27 )")

      ;;; NOISE LEVEL 70 ;;;
     (action_tile "db_70" "(setq changed_line $value)(file_line 29 )")
     (action_tile "clr_70" "(setq line_numb 30)(change_clr \"clr_70\")")
     (action_tile "length_70" "(setq changed_line $value)(file_line 31 )")
     (action_tile "width_70" "(setq changed_line $value)(file_line 32 )")

      ;;; NOISE LEVEL 75 ;;;
     (action_tile "db_75" "(setq changed_line $value)(file_line 34 )")
     (action_tile "clr_75" "(setq line_numb 35)(change_clr \"clr_75\")")
     (action_tile "length_75" "(setq changed_line $value)(file_line 36 )")
     (action_tile "width_75" "(setq changed_line $value)(file_line 37 )")

      ;;; NOISE LEVEL 80 ;;;
     (action_tile "db_80" "(setq changed_line $value)(file_line 39 )")
     (action_tile "clr_80" "(setq line_numb 40)(change_clr \"clr_80\")")
     (action_tile "length_80" "(setq changed_line $value)(file_line 41 )")
     (action_tile "width_80" "(setq changed_line $value)(file_line 42 )")

            ;;; NOISE LEVEL 85 ;;;
     (action_tile "db_85" "(setq changed_line $value)(file_line 44 )")
     (action_tile "clr_85" "(setq line_numb 45)(change_clr \"clr_85\")")
     (action_tile "length_85" "(setq changed_line $value)(file_line 46 )")
     (action_tile "width_85" "(setq changed_line $value)(file_line 47 )")


      ;;; NOISE LEVEL 90 ;;;
     (action_tile "db_90" "(setq changed_line $value)(file_line 49 )")
     (action_tile "clr_90" "(setq line_numb 50)(change_clr \"clr_90\")")
     (action_tile "length_90" "(setq changed_line $value)(file_line 51 )")
     (action_tile "width_90" "(setq changed_line $value)(file_line 52 )")


      ;;; NOISE LEVEL 95 ;;;
     (action_tile "db_95" "(setq changed_line $value)(file_line 54 )")
     (action_tile "clr_95" "(setq line_numb 55)(change_clr \"clr_95\")")
     (action_tile "length_95" "(setq changed_line $value)file_line 56 )")
     (action_tile "width_95" "(setq changed_line $value)(file_line 57 )")

      ;;; NOISE LEVEL 100 ;;;
     (action_tile "db_100" "(setq changed_line $value)(file_line 59 )")
     (action_tile "clr_100" "(setq line_numb 60)(change_clr \"clr_100\")")
     (action_tile "length_100" "(setq changed_line $value)(file_line 61 )")
     (action_tile "width_100" "(setq changed_line $value)(file_line 62 )")

      ;;; NOISE LEVEL X 1 ;;;
     (action_tile "db_x_1" "(setq changed_line $value)(file_line 64 )")
     (action_tile "custom_x_1" "(setq changed_line $value)(file_line 65 )")
     (action_tile "clr_x_1" "(setq line_numb 66)(change_clr \"clr_x_1\")")
     (action_tile "length_x_1" "(setq changed_line $value)(file_line 67 )")
     (action_tile "width_x_1" "(setq changed_line $value)(file_line 68 )")


      ;;; NOISE LEVEL X 2 ;;;
     (action_tile "db_x_2" "(setq changed_line $value)(file_line 70 )")
     (action_tile "custom_x_2" "(setq changed_line $value)(file_line 71 )")
     (action_tile "clr_x_2" "(setq line_numb 72)(change_clr \"clr_x_2\")")
     (action_tile "length_x_2" "(setq changed_line $value)(file_line 73 )")
     (action_tile "width_x_2" "(setq changed_line $value)(file_line 74 )")


      ;;; NOISE LEVEL X 3 ;;;
     (action_tile "db_x_3" "(setq changed_line $value)(file_line 76 )")
     (action_tile "custom_x_3" "(setq changed_line $value)(file_line 77 )")
     (action_tile "clr_x_3" "(setq line_numb 78)(change_clr \"clr_x_3\")")
     (action_tile "length_x_3" "(setq changed_line $value)(file_line 79 )")
     (action_tile "width_x_3" "(setq changed_line $value)(file_line 80 )")

      ;;; MISC ;;;
     (action_tile "merge_vpp" "(setq changed_line $value)(file_line 82 )")



(action_tile "cancel" "(done_dialog)")

 (start_dialog)
 (unload_dialog dcl_id)


;;; OPEN TO DETECT ;;;
       (setq opened_file_to_read_group (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))

;;; DETECT GROUP ;;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_1")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_2")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_3")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_4")
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq group_number "group_5")
        );


;;; END DETECT GROUP ;;;

;;; ACTION DETECT ;;;
        (read-line opened_file_to_read_group) ;;; trash-line

        (if (= (read-line opened_file_to_read_group) "1")
        (setq action "takeoff");; 1 means takeoff
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq action "put_down");; 2 means put down
        );

;;; END ACTION DETECT ;;;


;;; CALCULATE ;;;
        (read-line opened_file_to_read_group) ;;; trash-line


        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate 1);; 1 means max
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate 2);; 2 means equal
        );

;;; END CALCULATE ;;;


;;; PARAMETERS ;;;
        (read-line opened_file_to_read_group) ;;; trash-line


        (if (= (read-line opened_file_to_read_group) "1")
        (setq time 1);; 1 means day
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq calculate 2);; 2 means night
        );

        (setq count_air (atoi (read-line opened_file_to_read_group)))
        (setq time_impact (atoi (read-line opened_file_to_read_group)))

;;; END PARAMETERS ;;;

;;; NOISE 60 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_60 (atoi (read-line opened_file_to_read_group)))
        (setq clr_60 (atoi (read-line opened_file_to_read_group)))
        (setq length_60 (atoi (read-line opened_file_to_read_group)))
        (setq width_60 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 60 ;;;

;;; NOISE 65 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_65 (atoi (read-line opened_file_to_read_group)))
        (setq clr_65 (atoi (read-line opened_file_to_read_group)))
        (setq length_65 (atoi (read-line opened_file_to_read_group)))
        (setq width_65 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 65 ;;;

;;; NOISE 70 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_70 (atoi (read-line opened_file_to_read_group)))
        (setq clr_70 (atoi (read-line opened_file_to_read_group)))
        (setq length_70 (atoi (read-line opened_file_to_read_group)))
        (setq width_70 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 70 ;;;

;;; NOISE 75 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_75 (atoi (read-line opened_file_to_read_group)))
        (setq clr_75 (atoi (read-line opened_file_to_read_group)))
        (setq length_75 (atoi (read-line opened_file_to_read_group)))
        (setq width_75 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 75 ;;;

;;; NOISE 80 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_80 (atoi (read-line opened_file_to_read_group)))
        (setq clr_80 (atoi (read-line opened_file_to_read_group)))
        (setq length_80 (atoi (read-line opened_file_to_read_group)))
        (setq width_80 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 80 ;;;

;;; NOISE 85 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_85 (atoi (read-line opened_file_to_read_group)))
        (setq clr_85 (atoi (read-line opened_file_to_read_group)))
        (setq length_85 (atoi (read-line opened_file_to_read_group)))
        (setq width_85 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 85 ;;;

;;; NOISE 90 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_90 (atoi (read-line opened_file_to_read_group)))
        (setq clr_90 (atoi (read-line opened_file_to_read_group)))
        (setq length_90 (atoi (read-line opened_file_to_read_group)))
        (setq width_90 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 90 ;;;

;;; NOISE 95 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_95 (atoi (read-line opened_file_to_read_group)))
        (setq clr_95 (atoi (read-line opened_file_to_read_group)))
        (setq length_95 (atoi (read-line opened_file_to_read_group)))
        (setq width_95 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 95 ;;;


;;; NOISE 100 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_100 (atoi (read-line opened_file_to_read_group)))
        (setq clr_100 (atoi (read-line opened_file_to_read_group)))
        (setq length_100 (atoi (read-line opened_file_to_read_group)))
        (setq width_100 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE 100 ;;;

;;; NOISE X 1;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_1 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE X 1 ;;;

;;; NOISE X 2 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_2 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE X 2 ;;;

;;; NOISE X 3 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_3 (atoi (read-line opened_file_to_read_group)))

;;; END NOISE X 3 ;;;

;;; MISC ;;;

        (read-line opened_file_to_read_group) ;;; trash-line
        (setq merge_vpp (atoi (read-line opened_file_to_read_group)))

;;; END MISC ;;;



;;; FORMAT RAW SETTINGS ;;;

;;; MAKE NEW FILE LIST ;;;
(setq file_list (list 60 65 70 75 80 85 90 95 100))

;;;; DETECT CUSTOM X 1 ;;;
(if (= db_x_1 1)
  (progn
    (if (not (member custom_x_1 file_list))
        (progn
(setq allow_db_x_1 1);; so add to list
(setq file_list (append file_list (list custom_x_1)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_x_1 sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))
(setq opened_file_db_x_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa custom_x_1) "dB.txt" ) "w"))

(if (/= db_position 0)
    (progn
(if (/= db_position (- file_list_length 1))
  (progn
(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))

(while (setq sum1 (read-line opened_file_approx_1))
(if (setq sum2 (read-line opened_file_approx_2))
    (progn

(setq delta 5)
(setq step_from_less (- custom_x_1 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))
(setq med (/ (float (atoi sum1)) 2))
);; sum 2 == 0

(write-line (rtos med) opened_file_db_x_1)

); while

); progn poi\sition not end
); if positiom not end

); progn position not 0
); if position not 0


(if (= db_position 0)
(progn
(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_x_1))
(setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (*(atoi sum1) coeff ))
(write-line (rtos med) opened_file_db_x_1)
); while
(close opened_file_approx_1)
    ); progn position 0
); if position 0

(if (= db_position (- file_list_length 1))
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less (- custom_x_1 (nth (- db_position 1) sort_file_list)))
(setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (* (float (atoi sum1)) coeff ))
    (write-line (rtos med) opened_file_db_x_1)
); while
(close opened_file_approx_1)
); progn position end
); if position end


(close opened_file_db_x_1)

); progn not in list 60 65 70..
); if not in list 60 65 70..


); progn check box OK
); if check box OK



       ;;;; DETECT CUSTOM X 2 ;;;
(if (= db_x_2 1)
  (progn

    (if (not (member custom_x_2 file_list))
        (progn

(setq allow_db_x_2 1);; so add to list
(setq file_list (append file_list (list custom_x_2)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_x_2 sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))

(setq opened_file_db_x_2 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa custom_x_2) "dB.txt" ) "w"))

(if (/= db_position 0)
    (progn
(if (/= db_position (- file_list_length 1))
  (progn
(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))

(while (setq sum1 (read-line opened_file_approx_1))
(if (setq sum2 (read-line opened_file_approx_2))
    (progn

(setq delta 5)
(setq step_from_less (- custom_x_2 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))
(setq med (/ (float (atoi sum1)) 2))
);; sum 2 == 0

(write-line (rtos med) opened_file_db_x_2)
); while


); progn poi\sition not end
); if positiom not end

); progn position not 0
); if position not 0


(if (= db_position 0)
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_x_2))
(setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (*(atoi sum1) coeff ))
(write-line (rtos med) opened_file_db_x_2)
); while
(close opened_file_approx_1)
    ); progn position 0
); if position 0

(if (= db_position (- file_list_length 1))
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less (- custom_x_2 (nth (- db_position 1) sort_file_list)))

(setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (* (float (atoi sum1)) coeff ))
    (write-line (rtos med) opened_file_db_x_2)
); while
(close opened_file_approx_1)
    ); progn position end
); if position end

(close opened_file_db_x_2)

); progn not in list 60 65 70..
); if not in list 60 65 70..

); progn check box OK
); if check box OK



       ;;;; DETECT CUSTOM X 3 ;;;
(if (= db_x_3 1)
  (progn

    (if (not (member custom_x_3 file_list))
        (progn

(setq allow_db_x_3 1);; so add to list

(setq file_list (append file_list (list custom_x_3)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_x_3 sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))
(setq opened_file_db_x_3 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa custom_x_3) "dB.txt" ) "w"))


(if (/= db_position 0)
    (progn
(if (/= db_position (- file_list_length 1))
  (progn
(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq opened_file_approx_2 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(while (setq sum1 (read-line opened_file_approx_1))

(if (setq sum2 (read-line opened_file_approx_2))
    (progn

(setq delta 5)
(setq step_from_less (- custom_x_3 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))
(setq med (/ (float (atoi sum1)) 2))
);; sum 2 == 0

(write-line (rtos med) opened_file_db_x_3)

); while

); progn poi\sition not end
); if positiom not end

); progn position not 0
); if position not 0


(if (= db_position 0)
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_x_3))
(setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_2))

(setq med (*(atoi sum1) coeff ))

(write-line (rtos med) opened_file_db_x_3)
); while

(close opened_file_approx_1)

    ); progn position 0
); if position 0

(if (= db_position (- file_list_length 1))
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less (- custom_x_3 (nth (- db_position 1) sort_file_list)))

(setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (* (float (atoi sum1)) coeff ))
    (write-line (rtos med) opened_file_db_x_3)
); while
    
(close opened_file_approx_1)
    ); progn position end
); if position end

(close opened_file_db_x_3)

); progn not in list 60 65 70..
); if not in list 60 65 70..


); progn check box OK
); if check box OK
;;;;; END MAKE NEW FILE customdB.txt ;;;;;





(setq file_list nil)
(setq color_list nil)
(if db_60
    (progn
        (setq file_list (append file_list (list "60dB")))
        (setq color_list (append color_list (list clr_60)))
    )
)

(if db_65
    (progn
        (setq file_list (append file_list (list "65dB")))
        (setq color_list (append color_list (list clr_65)))
    )
)

(if db_70
    (progn
        (setq file_list (append file_list (list "70dB")))
        (setq color_list (append color_list (list clr_70)))
    )
)

(if db_75
    (progn
        (setq file_list (append file_list (list "75dB")))
        (setq color_list (append color_list (list clr_75)))
    )
)

(if db_80
    (progn
        (setq file_list (append file_list (list "80dB")))
        (setq color_list (append color_list (list clr_80)))
    )
)


(if db_85
    (progn
(setq file_list (append file_list (list "85dB")))
(setq color_list (append color_list (list clr_85)))
)
    )

(if db_90
    (progn
        (setq file_list (append file_list (list "90dB")))
    (setq color_list (append color_list (list clr_90)))
)
    )

(if db_95
    (progn
(setq file_list (append file_list (list "95dB")))
(setq color_list (append color_list (list clr_95)))
)
    )

(if db_100
    (progn
(setq file_list (append file_list (list "100dB")))
(setq color_list (append color_list (list clr_100)))
)
)

(if allow_db_x_1
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_1) "dB"))))
(setq color_list (append color_list (list clr_x_1)))
)
)

(if allow_db_x_2
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_2) "dB"))))
(setq color_list (append color_list (list clr_x_2)))
)
)

(if allow_db_x_3
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_3) "dB"))))
(setq color_list (append color_list (list clr_x_3)))
)
)




;(setq file_way (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\group_" group_number action ".txt"))
       ; ff (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" temp_name ".txt") "r")

(c:sperr file_list color)
(princ)
)