;|
;;By Steven Xu
;;-------------------------=={ vpcopy }==--------------------------;;
	Copies numbers of viewports needed for each discipline to their respective position
	This is the first lisp of the 4 part lisp of drawing set up
;;----------------------------------------------------------------------;;
	Version 1.0 - 2023 Feb 24th 
	- First version of the routine 
	- Requires vpcopy to be run before scaling
|;

(defun c:vpcopy ( / vp basept fireBase plumbBase HVACBase scheduleBase detailsBase xdiff ydiff fcount fcoord pcount pcoord hcount hcoord) 
	(setq vp (ssget "x")
     	basept (list -1488.61914274 1111.87831542)
        fireBase (list 2011.38085726 1111.87831542)
        plumbBase (list 5511.38085726 1111.87831542)
        HVACBase (list 9011.38085726 1111.87831542)
        scheduleBase (list 12511.38085726 1111.87831542)
        detailsBase (list 16011.38085726 1111.87831542)
	)
  	(command "_.COPY" vp "" basept fireBase)
	(command "_.COPY" vp "" basept plumbBase)
	(command "_.COPY" vp "" basept HVACBase)
  	(command "_.COPY" vp "" basept scheduleBase)
	(command "_.COPY" vp "" basept detailsBase)
	
	(setq xdiff 3500)
	(setq ydiff 2700)
  
	
	(setq fCopynum (getint "\nEnter number of viewports for Fire: "))
	(setq fcount 1)
		(while (< fcount fCopynum)
			(setq fcoord (list 2011.38 (+ (* fcount 2700) (nth 1 basept))))
			(setq fcount (1+ fcount))
    		(command "_.COPY" vp "" basept fcoord)
		)
	(setq pCopynum (getint "\nEnter number of viewports for plumbing: "))
	(setq pcount 1)
		(while (< pcount pCopynum)
			(setq pcoord (list 5511.38 (+ (* pcount 2700) (nth 1 basept))))
			(setq pcount (1+ pcount))
    		(command "_.COPY" vp "" basept pcoord)
		)
  	(setq hCopynum (getint "\nEnter number of viewports for HVAC: "))
	(setq hcount 1)
		(while (< hcount hCopynum)
			(setq hcoord (list 9011.38 (+ (* hcount 2700) (nth 1 basept))))
			(setq hcount (1+ hcount))
    		(command "_.COPY" vp "" basept hcoord)
		)
		

)
