; �.�.�������, lwp.lsp
; � ����� "���������������� ��� AutoCAD 2013-2015"
; (������������ "��� �����", 2015)
;

(defun lwp (points bulges / _mspace _np _clist _psa _lwpobj)
(vl-load-com)
; ������������ ������
(setq _mspace (vla-get-modelspace (vla-get-activedocument (vlax-get-acad-object))))
; �������������� ������ ��������� ����� � �������� ������ ���������
(setq _np (length points))
(while points
  (setq _clist (append _clist (car points)) points (cdr points))
);while
; ������������ ����������� �������
(setq _psa (vlax-make-safearray vlax-vbDouble (cons 1 (* 2 _np))))
(vlax-safearray-fill _psa _clist)
; ���������� ���������� ���������
(setq _lwpobj (vla-AddLightWeightPolyline _mspace _psa))
; ������������� ������� ���������
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
