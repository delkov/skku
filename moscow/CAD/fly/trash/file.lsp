      ; (setq ini_file (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))
      ;  (read-line ini_file)
      ;  (setq probe_line (atoi (read-line ini_file)))

       (setq changed_line "test");
      ; (setq current_text nil)

       (defun file_line (line_number /)
            ;  (alert "opened")
       (setq opened_file_to_read (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "r"))
       (setq text_list nil)
       (alert "opened")
       (while (setq temp_text (read-line opened_file_to_read))
       (setq text_list (append text_list (list temp_text)))
       )
       (alert "read")
       ;(setq true_text text)
       (close opened_file_to_read)

       (setq opened_file_to_write (open (strcat "C:\\Users\\delko_000\\Desktop\\fly\\settings.ini") "w"))
              (alert "opened")
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
         (alert "writed")

       (close opened_file_to_write)
       )

       (file_line 2 )