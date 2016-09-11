     ;file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     ;file_name_list (mapcar 'vl-filename-base file_list)

     (setq true_list (list "60dB.txt" "65dB.txt" "70dB.txt" "75dB.txt" "80dB.txt" "85dB.txt" "90dB.txt" "95dB.txt" "100dB.txt"))

     (setq temp_list (vl-directory-files (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\")  "*" 1))


(defun LM:ListDifference ( l1 l2 )
  (vl-remove-if '(lambda ( x ) (member x l2)) l1)
)

(setq diff (LM:ListDifference temp_list true_list))

;(mapcar 'vl-file-delete diff)

(setq delete_list '())

(while (>(length diff) 0)
	(alert "azazzzzzzzsszzza")
(setq delete_list (append delete_list (list (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (nth 0 diff))) ))
;(vla-file-delete (strcat "C:\\Users\\delko_000\\Desktop\\fly\\data\\" group_number "\\" action "\\" (nth 0 diff)))
(setq diff (LM:ListDifference diff (list (nth 0 diff))))
(alert "azazzzzzzzzzza")
)


(alert "azaza")
(mapcar 'vl-file-delete delete_list)