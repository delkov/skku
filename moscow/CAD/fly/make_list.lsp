
(setq group_number "group_1")
(setq action "takeoff")

(defun maked_list (custom_level /)
(setq file_list (append file_list (list custom_level)))
(setq sort_file_list (vl-sort file_list '<))
(setq db_position (vl-position custom_level sort_file_list))
(setq file_list_length (vl-list-length sort_file_list))

(setq opened_file_db_custom_level (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa custom_level) "dB.txt" ) "w"))
;(alert "test")
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
(setq step_from_less (- custom_level (nth (- db_position 1) sort_file_list)))
(setq med (+ (float (atoi sum2)) (* (float (/ (float (- (atoi sum1) (atoi sum2))) delta)) step_from_less)))
); progn sum2 no 0
); if sum2 not 0

(if (not (setq sum2 (read-line opened_file_approx_2)))

(setq med (+ (float (atoi last_sum2)) (* (float (/ (float (- (atoi sum1) (atoi last_sum2))) delta)) step_from_less)))
);; sum 2 == 0

(write-line (rtos med) opened_file_db_custom_level)

); while

(close opened_file_approx_1)
(close opened_file_approx_2)

); progn poi\sition not end
); if positiom not end

); progn position not 0
); if position not 0


(if (= db_position 0)
(progn
(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (+ db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less ( - (nth (+ db_position 1) sort_file_list) custom_level))
(setq coeff (+ 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (*(atoi sum1) coeff ))
(write-line (rtos med) opened_file_db_custom_level)
); while
(close opened_file_approx_1)
    ); progn position 0
); if position 0

(if (= db_position (- file_list_length 1))
(progn

(setq opened_file_approx_1 (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (itoa (nth (- db_position 1) sort_file_list)) "dB.txt" ) "r"))
(setq step_from_less (- custom_level (nth (- db_position 1) sort_file_list)))
(setq coeff (- 1 (*(/ (float step_from_less) 100) 3)))
(while (setq sum1 (read-line opened_file_approx_1))

(setq med (* (float (atoi sum1)) coeff ))
    (write-line (rtos med) opened_file_db_custom_level)
); while
(close opened_file_approx_1)
); progn position end
); if position end


(close opened_file_db_custom_level) 

          ; (setq true_file_list (append true_file_list (list "60dB")))

)