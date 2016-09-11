; Н.Н.Полещук, lwp.lsp
; В книге "Программирование для AutoCAD 2013-2015"
; (издательство "ДМК Пресс", 2015)
;

(defun lwp (points bulges / _mspace _np _clist _psa _lwpobj)
(vl-load-com)
; Пространство модели
(setq _mspace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
; Преобразование списка двумерных точек в линейный список координат
(setq _np (length points))
(while points
  (setq _clist (append _clist (car points)) points (cdr points))
);while
; Формирование безопасного массива
(setq _psa (vlax-make-safearray vlax-vbDouble (cons 1 (* 2 _np))))
(vlax-safearray-fill _psa _clist)
; Построение компактной полилинии
(setq _lwpobj (vla-AddLightWeightPolyline _mspace _psa))
; Корректировка кривизн сегментов
(if _lwpobj
  (progn 
    (while bulges
      (setq _sn (caar bulges) _sb (cadar bulges) bulges (cdr bulges))
      (vla-SetBulge _lwpobj _sn _sb)
    );while
  );progn
);if
(princ)
);defun
