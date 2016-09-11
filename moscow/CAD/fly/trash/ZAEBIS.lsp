


;;; GLOBAL ;;;
(setq break_set (ssadd))
(setq merge_vpp_points (ssadd))
(setq total_merge_vpp_list nil)
(setq temp_number 0)
(setq total_ent_list nil)
(setq file_list nil)
(setq color_list nil)
;(setq del_list 2)

;;;;; DRAWING SETING ;;;;;;;;;
  (setq
    oldEcho(getvar "CMDECHO")
    oldOsm(getvar "OSMODE")
     ;file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     ;file_name_list (mapcar 'vl-filename-base file_list)
     ;color_list  '(10 100 70 50 40 30 20)
    ; scale_list '(15 40 30 25 20 15 10 10 10 10 10)
  ); end setq
  (setvar "CMDECHO" 0)
  (setvar "OSMODE" 0)
      ;;;;; BEGIN_ACTIVE_X ;;;;;;;;;
(defun begin_activex ( / )
  (vl-load-com)
  (setq acad_application (vlax-get-acad-object))
  (setq active_document (vla-get-ActiveDocument acad_application))
  (setq model_space (vla-get-ModelSpace active_document))
  (setq paper_space (vla-get-PaperSpace active_document))
);  end of begin
;;;;; HIDE ERROR FUNCTION ;;;;;;;;;
  (defun *error* (msg)
   (setvar "CMDECHO" oldEcho)
   (setvar "OSMODE" oldOsm)
  (princ)
  ); end of *error*

(defun equal_add (Count Time Impact /)
(log (* (/ (float Count) Time) Impact))
);; EQUAL ADD

       (defun file_line (line_number /)
       (setq opened_file_to_read (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))
       (setq text_list nil)
       (while (setq temp_text (read-line opened_file_to_read))
       (setq text_list (append text_list (list temp_text)))
       ); WHILE
       (close opened_file_to_read)
       (setq opened_file_to_write (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "w"))
       (setq line_counter 1)
       (foreach temp_text text_list
        (if (= line_counter line_number)
        (write-line changed_line opened_file_to_write)
        ); if
        (if (/= line_counter line_number)
        (write-line temp_text opened_file_to_write)
        ); if
        (setq line_counter (+ line_counter 1))
       ); FOREACH
       (close opened_file_to_write)
       ); END FILE_LINE
(defun fill_clr (name nc /)
(setq dx (dimx_tile name) dy (dimy_tile name))
    (start_image name)
    (fill_image 0 0 dx dy nc)
(end_image)
); END FILL_CLR
(defun change_clr (name /)
(setq dx (dimx_tile name) dy (dimy_tile name))
(setq nc (acad_colordlg 80))

(if nc
   (progn
    (start_image name)
    (fill_image 0 0 dx dy nc)
    (setq changed_line (itoa nc))
    (file_line line_numb)
    (end_image)
   ); progn
 ); if
); END CHANGE_CLR
(defun sample (/ spSet ptLst Dr Ang sCurve oldEcho oldOsm dataLst fPt radius Ans)
;;; START DIALOG ;;;
(setq ini_file (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))
;(setq ent_for_del (entlast))
(if (< (setq dcl_id (load_dialog "sample.dcl")) 0) (exit))
(if (not (new_dialog "sample" dcl_id)) (exit))
;;;;;;;;;;;;;;; READ SETTING FROM SETTING.INI ;;;;;;;;;;;;;;;;;;;;;;;;;;;
; (start_image "image1")
; (slide_image 0 0 (dimx_tile "image1")(dimy_tile "image1")(findfile "BmpImage.sld"))
; (end_image)
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
     (fill_clr "clr_60" (atoi (read-line ini_file)))
     (set_tile "length_60" (read-line ini_file))
     (set_tile "width_60" (read-line ini_file))
          (set_tile "scale_60" (read-line ini_file))

;;; trash-line NOISE LEVEL--65
(read-line ini_file)
     (set_tile "db_65" (read-line ini_file))
     (fill_clr "clr_65" (atoi (read-line ini_file)))
     (set_tile "length_65" (read-line ini_file))
     (set_tile "width_65" (read-line ini_file))
               (set_tile "scale_65" (read-line ini_file))

;;; trash-line NOISE LEVEL--70
(read-line ini_file)
     (set_tile "db_70" (read-line ini_file))
     (fill_clr "clr_70" (atoi (read-line ini_file)))
     (set_tile "length_70" (read-line ini_file))
     (set_tile "width_70" (read-line ini_file))
               (set_tile "scale_70" (read-line ini_file))

;;; trash-line NOISE LEVEL--75
(read-line ini_file)
     (set_tile "db_75" (read-line ini_file))
     (fill_clr "clr_75" (atoi (read-line ini_file)))
     (set_tile "length_75" (read-line ini_file))
     (set_tile "width_75" (read-line ini_file))
               (set_tile "scale_75" (read-line ini_file))

;;; trash-line NOISE LEVEL--80
(read-line ini_file)
     (set_tile "db_80" (read-line ini_file))
     (fill_clr "clr_80" (atoi (read-line ini_file)))
     (set_tile "length_80" (read-line ini_file))
     (set_tile "width_80" (read-line ini_file))
               (set_tile "scale_80" (read-line ini_file))

;;; trash-line NOISE LEVEL--85
(read-line ini_file)
     (set_tile "db_85" (read-line ini_file))
     (fill_clr "clr_85" (atoi (read-line ini_file)))
     (set_tile "length_85" (read-line ini_file))
     (set_tile "width_85" (read-line ini_file))
               (set_tile "scale_85" (read-line ini_file))

;;; trash-line NOISE LEVEL--90
(read-line ini_file)
     (set_tile "db_90" (read-line ini_file))
     (fill_clr "clr_90" (atoi (read-line ini_file)))
     (set_tile "length_90" (read-line ini_file))
     (set_tile "width_90" (read-line ini_file))
               (set_tile "scale_90" (read-line ini_file))

;;; trash-line NOISE LEVEL--95
(read-line ini_file)
     (set_tile "db_95" (read-line ini_file))
     (fill_clr "clr_95" (atoi (read-line ini_file)))
     (set_tile "length_95" (read-line ini_file))
     (set_tile "width_95" (read-line ini_file))
               (set_tile "scale_95" (read-line ini_file))

;;; trash-line NOISE LEVEL--100
(read-line ini_file)
     (set_tile "db_100" (read-line ini_file))
     (fill_clr "clr_100" (atoi (read-line ini_file)))
     (set_tile "length_100" (read-line ini_file))
     (set_tile "width_100" (read-line ini_file))
               (set_tile "scale_100" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_1
(read-line ini_file)
     (set_tile "db_x_1" (read-line ini_file))
     (set_tile "custom_x_1" (read-line ini_file))
     (fill_clr "clr_x_1" (atoi (read-line ini_file)))
     (set_tile "length_x_1" (read-line ini_file))
     (set_tile "width_x_1" (read-line ini_file))
               (set_tile "scale_x_1" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_2
(read-line ini_file)
     (set_tile "db_x_2" (read-line ini_file))
     (set_tile "custom_x_2" (read-line ini_file))
     (fill_clr "clr_x_2" (atoi (read-line ini_file)))
     (set_tile "length_x_2" (read-line ini_file))
     (set_tile "width_x_2" (read-line ini_file))
               (set_tile "scale_x_2" (read-line ini_file))

;;; trah-line CUSTOM NOISE LEVEL x_3
(read-line ini_file)
     (set_tile "db_x_3" (read-line ini_file))
     (set_tile "custom_x_3" (read-line ini_file))
     (fill_clr "clr_x_3" (atoi (read-line ini_file)))
     (set_tile "length_x_3" (read-line ini_file))
     (set_tile "width_x_3" (read-line ini_file))
               (set_tile "scale_x_3" (read-line ini_file))

;;; trah-line MISC
(read-line ini_file)
     (set_tile "merge_vpp" (read-line ini_file))
     (set_tile "notify" (read-line ini_file))
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
          (action_tile "scale_60" "(setq changed_line $value)(file_line 23 )")

;;; NOISE LEVEL 65 ;;;
     (action_tile "db_65" "(setq changed_line $value)(file_line 25 )")
     (action_tile "clr_65" "(setq line_numb 26)(change_clr \"clr_65\")")
     (action_tile "length_65" "(setq changed_line $value)(file_line 27 )")
     (action_tile "width_65" "(setq changed_line $value)(file_line 28 )")
               (action_tile "scale_65" "(setq changed_line $value)(file_line 29 )")

      ;;; NOISE LEVEL 70 ;;;
     (action_tile "db_70" "(setq changed_line $value)(file_line 31 )")
     (action_tile "clr_70" "(setq line_numb 32)(change_clr \"clr_70\")")
     (action_tile "length_70" "(setq changed_line $value)(file_line 33 )")
     (action_tile "width_70" "(setq changed_line $value)(file_line 34 )")
               (action_tile "scale_70" "(setq changed_line $value)(file_line 35 )")

      ;;; NOISE LEVEL 75 ;;;
     (action_tile "db_75" "(setq changed_line $value)(file_line 37 )")
     (action_tile "clr_75" "(setq line_numb 38)(change_clr \"clr_75\")")
     (action_tile "length_75" "(setq changed_line $value)(file_line 39 )")
     (action_tile "width_75" "(setq changed_line $value)(file_line 40 )")
               (action_tile "scale_75" "(setq changed_line $value)(file_line 41 )")

      ;;; NOISE LEVEL 80 ;;;
     (action_tile "db_80" "(setq changed_line $value)(file_line 43 )")
     (action_tile "clr_80" "(setq line_numb 44)(change_clr \"clr_80\")")
     (action_tile "length_80" "(setq changed_line $value)(file_line 45 )")
     (action_tile "width_80" "(setq changed_line $value)(file_line 46 )")
               (action_tile "scale_80" "(setq changed_line $value)(file_line 47 )")

            ;;; NOISE LEVEL 85 ;;;
     (action_tile "db_85" "(setq changed_line $value)(file_line 49 )")
     (action_tile "clr_85" "(setq line_numb 50)(change_clr \"clr_85\")")
     (action_tile "length_85" "(setq changed_line $value)(file_line 51 )")
     (action_tile "width_85" "(setq changed_line $value)(file_line 52 )")
               (action_tile "scale_85" "(setq changed_line $value)(file_line 53 )")


      ;;; NOISE LEVEL 90 ;;;
     (action_tile "db_90" "(setq changed_line $value)(file_line 55 )")
     (action_tile "clr_90" "(setq line_numb 56)(change_clr \"clr_90\")")
     (action_tile "length_90" "(setq changed_line $value)(file_line 57 )")
     (action_tile "width_90" "(setq changed_line $value)(file_line 58 )")
               (action_tile "scale_90" "(setq changed_line $value)(file_line 59 )")


      ;;; NOISE LEVEL 95 ;;;
     (action_tile "db_95" "(setq changed_line $value)(file_line 61 )")
     (action_tile "clr_95" "(setq line_numb 62)(change_clr \"clr_95\")")
     (action_tile "length_95" "(setq changed_line $value)(file_line 63 )")
     (action_tile "width_95" "(setq changed_line $value)(file_line 64 )")
               (action_tile "scale_95" "(setq changed_line $value)(file_line 65 )")

      ;;; NOISE LEVEL 100 ;;;
     (action_tile "db_100" "(setq changed_line $value)(file_line 67 )")
     (action_tile "clr_100" "(setq line_numb 68)(change_clr \"clr_100\")")
     (action_tile "length_100" "(setq changed_line $value)(file_line 69 )")
     (action_tile "width_100" "(setq changed_line $value)(file_line 70 )")
               (action_tile "scale_100" "(setq changed_line $value)(file_line 71 )")

      ;;; NOISE LEVEL X 1 ;;;
     (action_tile "db_x_1" "(setq changed_line $value)(file_line 73 )")
     (action_tile "custom_x_1" "(setq changed_line $value)(file_line 74 )")
     (action_tile "clr_x_1" "(setq line_numb 75)(change_clr \"clr_x_1\")")
     (action_tile "length_x_1" "(setq changed_line $value)(file_line 76 )")
     (action_tile "width_x_1" "(setq changed_line $value)(file_line 77 )")
               (action_tile "scale_x_1" "(setq changed_line $value)(file_line 78 )")


      ;;; NOISE LEVEL X 2 ;;;
     (action_tile "db_x_2" "(setq changed_line $value)(file_line 80 )")
     (action_tile "custom_x_2" "(setq changed_line $value)(file_line 81 )")
     (action_tile "clr_x_2" "(setq line_numb 82)(change_clr \"clr_x_2\")")
     (action_tile "length_x_2" "(setq changed_line $value)(file_line 83 )")
     (action_tile "width_x_2" "(setq changed_line $value)(file_line 84 )")
               (action_tile "scale_x_2" "(setq changed_line $value)(file_line 85 )")


      ;;; NOISE LEVEL X 3 ;;;
     (action_tile "db_x_3" "(setq changed_line $value)(file_line 87 )")
     (action_tile "custom_x_3" "(setq changed_line $value)(file_line 88 )")
     (action_tile "clr_x_3" "(setq line_numb 89)(change_clr \"clr_x_3\")")
     (action_tile "length_x_3" "(setq changed_line $value)(file_line 90 )")
     (action_tile "width_x_3" "(setq changed_line $value)(file_line 91 )")
               (action_tile "scale_x_3" "(setq changed_line $value)(file_line 92 )")

      ;;; MISC ;;;
     (action_tile "merge_vpp" "(setq changed_line $value)(file_line 94 )")
          (action_tile "notify" "(setq changed_line $value)(file_line 95 )")


     ;;; CANCEL _OK ;;;
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
        (setq time 16);; 16 means day
        );

        (if (= (read-line opened_file_to_read_group) "1")
        (setq time 8);; 2 means night
        );

        (setq count_air (atoi (read-line opened_file_to_read_group)))
        (setq time_impact (atoi (read-line opened_file_to_read_group)))

                (if (or (<= count_air 0) (<= time_impact 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END PARAMETERS ;;;

;;; NOISE 60 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_60 (atoi (read-line opened_file_to_read_group)))
        (setq clr_60 (atoi (read-line opened_file_to_read_group)))
        (setq length_60 (atoi (read-line opened_file_to_read_group)))
        (setq width_60 (atoi (read-line opened_file_to_read_group)))
                (setq scale_60 (atoi (read-line opened_file_to_read_group)))

                        (if (or (<= length_60 0) (<= width_60 0) (<= scale_60 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 60 ;;;

;;; NOISE 65 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_65 (atoi (read-line opened_file_to_read_group)))
        (setq clr_65 (atoi (read-line opened_file_to_read_group)))
        (setq length_65 (atoi (read-line opened_file_to_read_group)))
        (setq width_65 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_65 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_65 0) (<= width_65 0) (<= scale_65 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 65 ;;;

;;; NOISE 70 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_70 (atoi (read-line opened_file_to_read_group)))
        (setq clr_70 (atoi (read-line opened_file_to_read_group)))
        (setq length_70 (atoi (read-line opened_file_to_read_group)))
        (setq width_70 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_70 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_70 0) (<= width_70 0) (<= scale_70 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 70 ;;;

;;; NOISE 75 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_75 (atoi (read-line opened_file_to_read_group)))
        (setq clr_75 (atoi (read-line opened_file_to_read_group)))
        (setq length_75 (atoi (read-line opened_file_to_read_group)))
        (setq width_75 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_75 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_75 0) (<= width_75 0) (<= scale_75 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 75 ;;;

;;; NOISE 80 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_80 (atoi (read-line opened_file_to_read_group)))
        (setq clr_80 (atoi (read-line opened_file_to_read_group)))
        (setq length_80 (atoi (read-line opened_file_to_read_group)))
        (setq width_80 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_80 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_80 0) (<= width_80 0) (<= scale_80 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 80 ;;;

;;; NOISE 85 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_85 (atoi (read-line opened_file_to_read_group)))
        (setq clr_85 (atoi (read-line opened_file_to_read_group)))
        (setq length_85 (atoi (read-line opened_file_to_read_group)))
        (setq width_85 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_85 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_85 0) (<= width_85 0) (<= scale_85 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 85 ;;;

;;; NOISE 90 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_90 (atoi (read-line opened_file_to_read_group)))
        (setq clr_90 (atoi (read-line opened_file_to_read_group)))
        (setq length_90 (atoi (read-line opened_file_to_read_group)))
        (setq width_90 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_90 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_90 0) (<= width_90 0) (<= scale_90 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 90 ;;;

;;; NOISE 95 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_95 (atoi (read-line opened_file_to_read_group)))
        (setq clr_95 (atoi (read-line opened_file_to_read_group)))
        (setq length_95 (atoi (read-line opened_file_to_read_group)))
        (setq width_95 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_95 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_95 0) (<= width_95 0) (<= scale_95 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 95 ;;;

;;; NOISE 100 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_100 (atoi (read-line opened_file_to_read_group)))
        (setq clr_100 (atoi (read-line opened_file_to_read_group)))
        (setq length_100 (atoi (read-line opened_file_to_read_group)))
        (setq width_100 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_100 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_100 0) (<= width_100 0) (<= scale_100 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE 100 ;;;

;;; NOISE X 1;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_1 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_1 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_1 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_x_1 0) (<= width_x_1 0) (<= scale_x_1 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 1 ;;;

;;; NOISE X 2 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_2 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_2 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_2 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_x_2 0) (<= width_x_2 0) (<= scale_x_2 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 2 ;;;

;;; NOISE X 3 ;;;

        (read-line opened_file_to_read_group) ;;; trash-line

        (setq db_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq custom_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq clr_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq length_x_3 (atoi (read-line opened_file_to_read_group)))
        (setq width_x_3 (atoi (read-line opened_file_to_read_group)))
                        (setq scale_x_3 (atoi (read-line opened_file_to_read_group)))

                                                (if (or (<= length_x_3 0) (<= width_x_3 0) (<= scale_x_3 0)) 
        (progn
            (alert "Wrong! Must be > 0")
            (exit)
        )
        )

;;; END NOISE X 3 ;;;

;;; MISC ;;;

        (read-line opened_file_to_read_group) ;;; trash-line
        (setq merge_vpp (atoi (read-line opened_file_to_read_group)))
                (setq notify (atoi (read-line opened_file_to_read_group)))

;;; END MISC ;;;
;;; FORMAT RAW SETTINGS ;;;
;;; MAKE NEW FILE LIST ;;;
(setq file_list (list 60 65 70 75 80 85 90 95 100))
(setq allow_db_x_1 0)
(setq allow_db_x_2 0)
(setq allow_db_x_3 0)
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
(setq last_sum2 sum2)
(setq delta 5)
(setq step_from_less (- custom_x_1 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))

(setq med (+ (float (atoi last_sum2)) (* (float (/ (float (- (atoi sum1) (atoi last_sum2))) delta)) step_from_less)))
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
(setq last_sum2 sum2)

(setq delta 5)
(setq step_from_less (- custom_x_2 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))
(setq med (+ (float (atoi last_sum2)) (* (float (/ (float (- (atoi sum1) (atoi last_sum2))) delta)) step_from_less)))
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
(setq last_sum2 sum2)
(setq delta 5)
(setq step_from_less (- custom_x_3 (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))
(setq med (+ (float (atoi last_sum2)) (* (float (/ (float (- (atoi sum1) (atoi last_sum2))) delta)) step_from_less)))
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
;;;;; END MAKE NEW FILE LIST ;;;;;
(setq file_list nil)
(setq color_list nil)
(setq scale_list nil)
(setq length_list nil)
(setq width_list nil)

(if (= db_60 1)
    (progn
     ; (alert"60")
        (setq file_list (append file_list (list "60dB")))
        (setq color_list (append color_list (list clr_60)))
        (setq scale_list (append scale_list (list scale_60)))
        (setq length_list (append length_list (list length_60)))
        (setq width_list (append width_list (list width_60)))
    )
)

(if (= db_65 1)
    (progn
        (setq file_list (append file_list (list "65dB")))
        (setq color_list (append color_list (list clr_65)))
        (setq scale_list (append scale_list (list scale_65)))
                (setq length_list (append length_list (list length_65)))
        (setq width_list (append width_list (list width_65)))
    )
)

(if (= db_70 1)
    (progn
        (setq file_list (append file_list (list "70dB")))
        (setq color_list (append color_list (list clr_70)))
        (setq scale_list (append scale_list (list scale_70)))
                (setq length_list (append length_list (list length_70)))
        (setq width_list (append width_list (list width_70)))
    )
)

(if (= db_75 1)
    (progn
        (setq file_list (append file_list (list "75dB")))
        (setq color_list (append color_list (list clr_75)))
        (setq scale_list (append scale_list (list scale_75)))
                (setq length_list (append length_list (list length_75)))
        (setq width_list (append width_list (list width_75)))
    )
)

(if (= db_80 1)
    (progn
        (setq file_list (append file_list (list "80dB")))
        (setq color_list (append color_list (list clr_80)))
        (setq scale_list (append scale_list (list scale_80)))
                (setq length_list (append length_list (list length_80)))
        (setq width_list (append width_list (list width_80)))
    )
)


(if (= db_85 1)
    (progn
(setq file_list (append file_list (list "85dB")))
(setq color_list (append color_list (list clr_85)))
        (setq scale_list (append scale_list (list scale_85)))
                (setq length_list (append length_list (list length_85)))
        (setq width_list (append width_list (list width_85)))
)
    )

(if (= db_90 1)
    (progn
    (setq file_list (append file_list (list "90dB")))
    (setq color_list (append color_list (list clr_90)))
        (setq scale_list (append scale_list (list scale_90)))
                (setq length_list (append length_list (list length_90)))
        (setq width_list (append width_list (list width_90)))
)
    )

(if (= db_95 1)
    (progn
(setq file_list (append file_list (list "95dB")))
(setq color_list (append color_list (list clr_95)))
        (setq scale_list (append scale_list (list scale_95)))
                (setq length_list (append length_list (list length_95)))
        (setq width_list (append width_list (list width_95)))
)
    )

(if (= db_100 1)
    (progn
(setq file_list (append file_list (list "100dB")))
(setq color_list (append color_list (list clr_100)))
        (setq scale_list (append scale_list (list scale_100)))
                (setq length_list (append length_list (list length_100)))
        (setq width_list (append width_list (list width_100)))
)
)

(if (= allow_db_x_1 1)
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_1) "dB"))))
(setq color_list (append color_list (list clr_x_1)))
        (setq scale_list (append scale_list (list scale_x_1)))
                (setq length_list (append length_list (list length_x_1)))
        (setq width_list (append width_list (list width_x_1)))
)
)

(if (= allow_db_x_2 1)
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_2) "dB"))))
(setq color_list (append color_list (list clr_x_2)))
        (setq scale_list (append scale_list (list scale_x_2)))
                (setq length_list (append length_list (list length_x_2)))
        (setq width_list (append width_list (list width_x_2)))
)
)

(if (= allow_db_x_3 1)
(progn
(setq file_list (append file_list (list (strcat (itoa custom_x_3) "dB"))))
(setq color_list (append color_list (list clr_x_3)))
        (setq scale_list (append scale_list (list scale_x_3)))
                (setq length_list (append length_list (list length_x_3)))
        (setq width_list (append width_list (list width_x_3)))
)
)

; (if (= calculate 1)
;   (setq width_add 0);
; )

 (if (= calculate 2)
   (setq equ_level (equal_add count_air (* time 3600) time_impact))
 )

(princ "\n<<< Select spline >>>")
  (if (setq spSet (ssget  '((0 . "SPLINE"))))    
    (progn
;;;;; MERGE VPP ? ;;;;
      (if (= merge_vpp 1)
        (progn
(princ "\n<<< Select spline for merge >>>")
          (if (setq merge_set (ssget  '((0 . "SPLINE"))))
          (progn   
            )
          )
          )
        )
;;; END MERGE VPP ;;;     
;;;;;;;;; FILE CYCLE ::::::::::::::::
    (foreach temp_name file_list

      (setq
        total_sel (ssadd) 
        count_spline (sslength spSet)
        temp_number 0
        merge_vpp_points (ssadd)
      ); end setq  
;;;;;;;;; SPLINE CYCLE ;;;;;;;;;;;;;;;;;
      (setq break_set (ssadd))

      (repeat count_spline
      (setq 
        sCurve(vlax-ename->vla-object(ssname spSet temp_number))
        dataLst '()
        end_point nil
        start_point nil
        temp_number (+ temp_number 1)
      ); end setq

      (setq
        width_coeff (/ (float (car width_list)) 100) 
        length_coeff  (/ (float (car length_list)) 100)
        radius_length '()
        counter_test 1
        step (* 1000 length_coeff)
        temp_length 0
        point_list (list )
        spline_length (vlax-curve-getDistAtPoint sCurve (vlax-curve-getEndPoint sCurve))
        true_count (+ (/ spline_length step) 1)
        ok_point 1
      ); end setq
;;;;;;;;;;;;;; READ FILE DATA ;;;;;;;;;;;;;;;;
      (setq
        ff (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" temp_name ".txt") "r")
        ;trash_line (read-line ff)
      ); end setq


      (while (and (> ok_point 0) (<= counter_test true_count))
        (setq probe_line (read-line ff))

        (if (= probe_line ())
          (setq ok_point 0)
        )

        (if (/= probe_line ())
          (progn
            (setq temp_radius (* (float (atoi probe_line)) width_coeff))
            (setq counter_test (+ counter_test 1))

            (setq point_list (append point_list (list  (vlax-curve-getPointAtDist sCurve temp_length)))) 
                        (setq temp_length (+ temp_length step))
            (setq radius_length (append radius_length (list temp_radius)))
          ); end progn
        ); end if
      ); end while

      (foreach pt point_list

        (setq Dr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve pt)))
        (setq
          Ang (- pi(atan(/(car Dr)(cadr Dr))))
          dataLst (append dataLst (list(list(trans pt 0 1) Ang))); 
        ); setq
      ); end foreach 

      (setq counter 0)  
      (while dataLst
        (setq 
          fPt (caar dataLst)
          Ang (cadar dataLst)
          radius (car radius_length)
        ); end setq
 ;;;;;;;;;; MAKE TRELISTICK (counter = 0) ;;;;;;;;;;;
        (if (= counter 0)  
          (progn
            (setq double_der (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt)));
            (setq base_anglee_point fPt)
            

            (if (> (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (+ Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (+ Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn   
            ); if

            (if (<= (cadr double_der) 0)
              (progn
                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 2.34)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq start_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt   (- Ang 1.56)   radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq med_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)

                (command "_.line" fPt 
                (trans(polar fPt  (- Ang 0.78)  radius)0 1)"")
                (setq temp_line (vlax-ename->vla-object (entlast)))
                (setq end_angle_point (list (vlax-curve-getEndPoint temp_line)))
                (vla-Delete temp_line)
              ); progn
            ) ; if
          ); progn
        ); if
;;;;;;;;;; SPLIT SPLINE ;;;;;;;;;;;;;;
          (if radius
            (progn
              (if (< (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                  ;(alert "split1")
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius)0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getEndPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getStartPoint temp_line))))
                  (entdel (entlast))
                  ;(entdel (entlast))
                )
              ); end if

              (if (>= (cadr (vlax-curve-getFirstDeriv sCurve (vlax-curve-getParamAtPoint sCurve fPt))) 0)
                (progn
                 ; (alert "split2")
                  (command "_.pline"  (trans(polar fPt Ang radius)0 1) (trans(polar fPt (- Ang Pi) radius) 0 1) "")
                  (setq temp_line (vlax-ename->vla-object (entlast)))
                  (setq end_point (append end_point (list (vlax-curve-getStartPoint temp_line))))  
                  (setq start_point (append start_point (list (vlax-curve-getEndPoint temp_line))))
                  (entdel (entlast))
                  ;(entdel (entlast))
                ); progn
              ); end if
            ); progn
          ); if

          (setq 
            dataLst (cdr dataLst)
            radius_length (cdr radius_length)
          ); setq



;;;;; BREAK at the END of the curve FOR #2 ;;;;;;;
(if (and (= (length dataLst) 1) (> ok_point 0))
  (progn
         (command "_.pline"  (trans(polar fPt Ang (* radius 1.1)) 0 1) (trans(polar fPt (- Ang Pi) (* radius 1.1)) 0 1) "")
         (ssadd (entlast) break_set) 
         (if (= notify 1)
         (alert "SHORT SPLINE! DONT FORGET TRIM IT!");;; NOTIFY !!!!!
         ); if
         (setq total_ent_list (append total_ent_list (list (entlast))))

  )
);


          (if (not dataLst)
            (princ)
          ); if
          (setq counter (+ counter 1))


        ); end while datalist



       (if (= ok_point 1)
          (setq point_list_for_sort point_list)
          (setq point_list (append point_list (list (vlax-curve-getEndPoint sCurve))))
           
       ); if

        (close ff)

        (setq ff nil)
        (setq temp_spline nil)
        (setq intersect_probe nil)
        (setq intersect_probe_again nil)
        (setq intersect_probe_again_2 nil)
;; TRELISTNIK zasovavaem k rectanglam ;;;;
(setq base_start_angle (list (car start_point)))
(setq base_end_angle (list (car end_point)))

  (setq temp_angle_spline  (append base_start_angle  end_angle_point med_angle_point start_angle_point base_end_angle base_start_angle))

  (command "._PLINE")
  (apply 'command temp_angle_spline);
  (command "")
  
  (ssadd (entlast) total_sel)
;;;;;;;;;;; END TRELISTNIK ;;;;;;;;;;;;;;;;
;;;;;;;;; CREATE RECTANGLE'S POINT FOR MERGE VPP ;;;;;;;;;;;;;;;;
(if (= merge_vpp 1) 
  (progn
     (if (ssmemb (ssname spSet (- temp_number 1)) merge_set)
        (progn
        (command ".point" (car end_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))
        ; (setq total_ent_list (append total_ent_list (list (entlast))))
        (command "point" (car start_point))
        (ssadd (entlast) merge_vpp_points)
        (setq total_merge_vpp_list (append total_merge_vpp_list (list (entlast))))
  ;  (setq total_ent_list (append total_ent_list (list (entlast))))
        ); progn
    ); if
  ); progn
); if
;;; DRAW RECTANGLES ;;;
        (repeat  (- (length start_point) 1) 
        (setq temp_spline (append (list (car start_point) (cadr start_point) (cadr end_point) (car end_point) (car start_point))))

  (command "._PLINE")
  (apply 'command temp_spline);
  (command "")
  ;(alert "first done")
        (setq temp_spline_vla (vlax-ename->vla-object (entlast)))
        (setq intersect_probe (vlax-invoke temp_spline_vla 'IntersectWith temp_spline_vla acextendnone))

        (if (> (length intersect_probe) 12)

               (progn
               (entdel (entlast))
               (setq temp_spline_shit (append (list (car start_point) (cadr start_point) (car end_point) (cadr end_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit);
               (command "" )
               )
        )
        (setq temp_spline_shit (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again (vlax-invoke temp_spline_shit 'IntersectWith temp_spline_shit acExtendNone))

         (if (> (length intersect_probe_again) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again (append (list (car start_point) (car end_point) (cadr end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )
        
        (setq temp_spline_shit_2 (vlax-ename->vla-object (entlast)))
        (setq intersect_probe_again_2 (vlax-invoke temp_spline_shit_2 'IntersectWith temp_spline_shit_2 acExtendNone))

         (if (> (length intersect_probe_again_2) 12)
               (progn
               (entdel (entlast));
               (setq temp_spline_shit_again_2 (append (list (car start_point) (cadr end_point) (car end_point) (cadr start_point)  (car start_point))))
               (command "._PLINE")
               (apply 'command temp_spline_shit_again);
               (command ""  )
         )
         )

        (ssadd (entlast) total_sel)
        (setq start_point (cdr start_point))
        (setq end_point (cdr end_point))

        ); repeat
;; END DRAW RECTANGLES ;;;
      ); END SPLINE CYCLE!!!
;;;;;;;;;;;;; MERGE VPP ;;;;;;;
(defun LM:ConvexHull ( lst / ch p0 )
    (cond
        (   (< (length lst) 4) lst)
        (   (setq p0 (car lst))
            (foreach p1 (cdr lst)
                (if (or (< (cadr p1) (cadr p0))
                        (and (equal (cadr p1) (cadr p0) 1e-8) (< (car p1) (car p0)))
                    )
                    (setq p0 p1)
                )
            )
            (setq lst
                (vl-sort lst
                    (function
                        (lambda ( a b / c d )
                            (if (equal (setq c (angle p0 a)) (setq d (angle p0 b)) 1e-8)
                                (< (distance p0 a) (distance p0 b))
                                (< c d)
                            )
                        )
                    )
                )
            )
            (setq ch (list (caddr lst) (cadr lst) (car lst)))
            (foreach pt (cdddr lst)
                (setq ch (cons pt ch))
                (while (and (caddr ch) (LM:Clockwise-p (caddr ch) (cadr ch) pt))
                    (setq ch (cons pt (cddr ch)))
                )
            )
            ch
        )
    )
)

;; Clockwise-p  -  Lee Mac
;; Returns T if p1,p2,p3 are clockwise oriented or collinear
                 
(defun LM:Clockwise-p ( p1 p2 p3 )
    (<  (-  (* (- (car  p2) (car  p1)) (- (cadr p3) (cadr p1)))
            (* (- (cadr p2) (cadr p1)) (- (car  p3) (car  p1)))
        )
        1e-8
    )
)


            (repeat (setq i (sslength merge_vpp_points))
                (setq l (cons (cdr (assoc 10 (entget (ssname merge_vpp_points (setq i (1- i)))))) l))
            )
            (setq l (LM:ConvexHull l))
            (entmakex
                (append
                    (list
                       '(000 . "LWPOLYLINE")
                       '(100 . "AcDbEntity")
                       '(100 . "AcDbPolyline")
                        (cons 90 (length l))
                       '(070 . 1)
                    )
                    (mapcar '(lambda ( x ) (cons 10 x)) l)
                )
            )

        (ssadd (entlast) total_sel)
      ;  (setq merge_vpp_points (ssadd))
(setq l nil)
;;;;;;;;; UNION AREAS ;;;;;;;;;;;;
(setq 
  areas nil
  ss nil
  el nil
)
(defun c:mp( / )
  
  (defun getfromlast(e / s)
    (setq
     s (ssadd)
    )
      (while (setq e (entnext e))
        (setq
          s (ssadd e s)
        )
      )
  ); GETFROMLAST
  (setq ss total_sel)
  (setq el (entlast))
  
  (command ".region" ss "")  
  (command ".union" (getfromlast el) "")

  (setq el (entlast))
  (command ".explode" (entlast) )  
  (setq el_2 (entlast))

  (setq areas (getfromlast el))
  (setq explode_counter 0)

(if (= (cdr (cadr (entget (ssname areas 1)))) "REGION")
  (progn
    (setq total_fit (ssadd))

    (repeat (sslength areas)
    (setq el (entlast))
    (command ".explode" (ssname areas explode_counter))
    (command ".pedit" (entlast) "y" "j" (getfromlast el) "" "")
    (setq total_fit (ssadd (entlast) total_fit))  

      (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")
      ); setq

 (if (= calculate 2)
(progn
  (setq temp_name (strcat (itoa (fix (+ (atoi (vl-string-right-trim "dB" str)) equ_level)))"dBe"))
)
 )

      (write-line (strcat "*" temp_name ", ---" temp_name "---") fn)
      (write-line (strcat "A,.5,-0.5,[\""temp_name"\",STANDARD,S=0.2,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen temp_name))2 3)) fn)
      (close fn)



      (if (= (tblsearch "LTYPE" temp_name) nil)
        (command ".-linetype" "load" "*" file "")
      ); end if

      (vl-file-delete file)
      (command "._CHANGE" (entlast) "" "Properties" "LType" temp_name "")
      (command "._CHANGE" (entlast) "" "Properties" "LtScale" (car scale_list) "")
      (command "._CHANGE" (entlast) "" "Properties" "Color" (car color_list) "")

      (setq explode_counter (+ explode_counter 1))

     ); repeat


(setq fit_counter 0)
(repeat (sslength total_fit)
 (command ".pedit" (ssname total_fit fit_counter) "Fit" "")
 (setq fit_counter (+ fit_counter 1))
); repeat fit

);progn
);if



(if (= (cdr (cadr (entget (ssname areas 1)))) "LINE")
  (progn
  ;  (alert "one")

    (command "_.pedit" "_m" (getfromlast el) "" "Y" "J" "" "")

 (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")

      ); setq

  (if (= calculate 2)
    (progn
  (setq temp_name (strcat (itoa (fix (+ (atoi (vl-string-right-trim "dB" str)) equ_level)))"dBe"))
;(alert "azaz")
)
 )


      (write-line (strcat "*" temp_name ", ---" temp_name "---") fn)

            (write-line (strcat "A,1.5,-0.05,[\""temp_name"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen temp_name))2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" temp_name) nil)
        (command ".-linetype" "load" "*" file "")
      ); end if

      (vl-file-delete file)


    (setq closed_pline (getfromlast el_2))
    (setq closed_pline_counter 0)

    (repeat (sslength closed_pline)

    (command ".pedit" (ssname closed_pline closed_pline_counter) "Spline" "")
    (command ".pedit" (ssname closed_pline closed_pline_counter) "L" "On" "")

     
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "LType" temp_name "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "LtScale" (car scale_list) "")
      (command "._CHANGE" (ssname closed_pline closed_pline_counter) "" "Properties" "Color" (car color_list) "")
      
      (setq closed_pline_counter (+ closed_pline_counter 1))
    ); repeat

    ); progn 
  ); if

      (if (/= (cdr color_list) nil)
        (setq color_list (cdr color_list))
      ); end if

      (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

                  (if (/= (cdr scale_list) nil)
        (setq scale_list (cdr scale_list))
      ); end if

            (if (/= (cdr width_list) nil)
        (setq width_list (cdr width_list))
      ); end if


  (princ)
)  ;;;; end MP


(c:mp) 
    (setq total_ent_list (append total_ent_list (list (entlast))))
      ); END FILE CYCLE!!!

(setq total_merge_vpp_list (mapcar 'vlax-ename->vla-object total_merge_vpp_list))
(mapcar 'vla-Delete total_merge_vpp_list)

      ); end progn --- empty select
    ); end if --- empty select

;;;;;;;;; RESET DEFAULT SETTING;;;;;
    (setvar "CMDECHO" oldEcho)
    (setvar "OSMODE" oldOsm)

  (princ)

  ); END SAMPLE


