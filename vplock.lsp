;|
;;By Steven Xu
;;-------------------------=={ vplock }==--------------------------;;
	locks the layout to its corresponding viewport, will autolock the viewport
 	This is the final lisp of the 4 part lisp of drawing set up 
;;----------------------------------------------------------------------;;
	Version 1.0 - 2023 Mar 10th 
	- First version of the routine 
	- Requires the names of the layout to be correct, as it is how this lisp knows where the coordinates
	  of the viewport is
	- Planning to implement auto changing the text on the title block to match layout name
|;
(defun c:vplock ( / scalenum basept1 basept2 laypt1 laypt2) 
	;(setq vp (ssget "x")
     	;basept (list -1488.61914274 1111.87831542)
        ;diagpt (list 1482.09 -1102.77);not used
       	;fireBase (list 2011.38085726 1111.87831542)
        ;plumbBase (list 5511.38085726 1111.87831542)
        ;HVACBase (list 9011.38085726 1111.87831542)
        ;scheduleBase (list 12511.38085726 1111.87831542)
        ;detailsBase (list 16011.38085726 1111.87831542)
        ;layoutBase(list 0.16643341 23.02817884)
        ;layoutDiag(list 31.16 -0.04);not used
	;)
	(setq scalenum (getint "\nEnter scale:1/ "))
	(setq xdiff (/ (* 3500 scalenum) 8))
	(setq ydiff (/ (* 2700 scalenum) 8))
	(setvar "ctab" "M-1.01")
  
	(command "_.MSPACE")
	(setq basept1 (getpoint "\nSelect top left point of model space vp: ")
    basept2 (getpoint "\nSelect bottom left point of model space vp: ")
	)      
	(command "_.PSPACE")
    (setq laypt1 (getpoint "\nSelect top left point of paper space rectangle: ")
    laypt2 (getpoint "\nSelect bottom left point of paper space rectangle: ")
  	)
 	(foreach layout (layoutlist)
  		(setvar "ctab" layout)
		(setq name (getvar "ctab"))
		(setq xnum (atoi (substr name 3 1)))
		(setq ynum (atoi (substr name 5 2)))
    
		(setq x1 (+ (car basept1) (* xdiff xnum))) ; calculate x coordinate as a+b*c
		(setq y1 (+ (cadr basept1) (* ydiff (- ynum 1)))) ; calculate y coordinate as d+e*(f-1)
    	(setq pt1 (list x1 y1)) ;set the point using the x and y coordinates
    
		(setq x2 (+ (car basept2) (* xdiff xnum))) ; calculate x coordinate as a+b*c
		(setq y2 (+ (cadr basept2) (* ydiff (- ynum 1)))) ; calculate y coordinate as d+e*(f-1)
    	(setq pt2 (list x2 y2)) ;set the point using the x and y coordinates
  		
  		;(setvar "_CANNOSCALE" "1/8\" = 1'-0\"")
  		(aspace pt1 pt2 laypt1 laypt2)
		(command "layout" "set" x)
		(command "mview" "lock" "on" "all" "")
  	)
)

(defun aspace ( p1 p2 p3 p4 / vp a b c d na vplocked )
 
(if (= 1 (getvar "cvport"))
    (command "_.mspace")
);if
(setq       na (acet-currentviewport-ename)
      vplocked (acet-viewport-lock-set na nil) ;unlock the viewport if needed.
                                               ;sets vplocked to the ename of viewport if locked/nil if not
);setq
 
(command "_.pspace")
(setq p3 (trans p3 1 3))
(if p4
    (setq p4 (trans p4 1 3))
);if
 
(command "_.mspace")
 
(acet-ucs-cmd (list "_view"))
 
(setq p1 (trans p1 0 1));setq
(if p2
    (setq p2 (trans p2 0 1))
);if
 
(if (not p2)
    (progn
     (setq vp (acet-currentviewport-ename)
           vp (entget vp)
           vp (cdr (assoc 41 vp))
            a (/ vp (getvar "viewsize"))
     );setq
    );progn
    (setq p2 (list (car p2) (cadr p2) (caddr p1)) ;rk added 5:39 PM 9/1/97
          p4 (list (car p4) (cadr p4) (caddr p3))
           a (/ (distance p3 p4)
                (distance p1 p2)
             )
    );setq else
);if
 
(setq c (trans p3 3 2)
      c (trans c 2 1)
);setq
(if p4
    (setq d (trans p4 3 2)
          d (trans d 2 1)
    );setq
);if
(if (and p2
         p4
         (not (equal (angle p1 p2) (angle c d) 0.0001))
    );and
    (progn
     (acet-ucs-cmd (list "_z" (* (- (angle p1 p2) (angle c d))
                              (/ 180.0 pi)
                           )
                   );list
     );acet-ucs-cmd
     (command "_.plan" "_c")
     (acet-ucs-cmd (list "_p"))
    );progn then
);if
(if (and p2 p4)
    (command "_.zoom" (strcat (rtos a 2 6) "xp"))
);if
(setq b (trans p3 3 2)
      b (trans b 2 1)
);setq
(command "_.-pan" p1 b)
 
;restore the original ucs
(acet-ucs-cmd (list "_p"))
 
(if vplocked
    (acet-viewport-lock-set na T) ;re-lock the viewport
)
 
(if (and p2 p4
         (or (not (equal (caddr p1) (caddr p2) 0.0001))
             (not (equal (caddr c) (caddr d) 0.0001))
         );or
    );and
    (progn
     (princ "\nWarning: Selected Points are not parallel to view")
     (princ "\nCommand results may not be obvious")
    );progn
);if
(princ "\nPaper space = Model space")
(princ (strcat "\n"
               (substr "             " 1
                       (max (- 11 (strlen (rtos 1.0))) 0)
               );substr
               (rtos 1.0)
               " = "
               (rtos (/ 1.0 a))
       );strcat
);princ
(princ (strcat "\nCurrent zoom factor = " (rtos a) "xp"))
);defun alignspace