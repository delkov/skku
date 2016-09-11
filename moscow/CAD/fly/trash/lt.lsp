     file_list (vl-directory-files "c:\\Users\\delko_000\\Desktop\\fly\\data" "*" 1)
     file_name_list (mapcar 'vl-filename-base file_list)

(setq temp_name (car file_name_list))
      (setq
        str   temp_name
        file  (strcat (getvar 'dwgprefix) (vl-filename-base (getvar 'dwgname)) "_mylt.lin")
        fn    (open file "w")
      ;  exprt (getvar 'expert)
      )
      (write-line (strcat "*" str ", ---" str "---") fn)
      (write-line (strcat "A,1.5,-0.05,[\""str"\",STANDARD,S=0.1,U=0.0,X=-0.0,Y=-.05],"(rtos (* -0.1 (strlen str))2 3)) fn)
      (close fn)
        ;(setvar 'expert 5)

      (if (= (tblsearch "LTYPE" temp_name) nil)
        (command ".-linetype" "load" "*" file "")
      ); end if
          ;(setvar 'expert exprt)
      (vl-file-delete file)



      (command "._CHANGE" (entlast) "" "Properties" "LType" temp_name "")
      (command "._CHANGE" (entlast) "" "Properties" "LtScale" (car scale_list) "")
      (command "._CHANGE" (entlast) "" "Properties" "Color" (car color_list) "")