(defun c:SlideImage (/ Dcl_Id%)
(setq Dcl_Id% (load_dialog "slide.dcl"));<-- your dcl name
(new_dialog "SlideImage" Dcl_Id%)
(princ (strcat "nX pixels = " (itoa (dimx_tile "image1"))
", Y pixels = " (itoa (dimy_tile "image1")))
);princ
(princ)
(start_image "image1")
(slide_image 0 0 (dimx_tile "image1")(dimy_tile "image1")(findfile "BmpImage.sld"))
(end_image)
(action_tile "accept" "(done_dialog)")
(start_dialog)
(unload_dialog Dcl_Id%)
(princ)
);defun c:SlideImage
;------------------------
