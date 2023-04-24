(defun removewipeouts()
	(setvar "pickstyle" 0)
	(setq b (ssget "x" '((0 . "wipeout"))))
	(if (/= b nil)
		(command "._erase" b "")
		(prompt "No wipeouts to be removed.\n")
	)
  	;if nothing to remove it will return unkown command for whatever reason
)

(defun ZeroZ ()
	;;Zero evertying on the Z axis, not exactly sure if I want this in there
	;;Can be helpful to do this after seperating the layers into different x and y values
	(command "MOVE" (ssget "x") "" "0,0,0" "0,0,1e99")
	(command "MOVE" (ssget "p") "" "0,0,0" "0,0,-1e99")
)

(defun okill()
	;(command-s "select" "all")
	(command-s "-overkill" "all" "" "")
)

(defun allbylayer ( / everything)
	;(command-s "select" "all")
  	(setq everything (ssget "x"))
	(command "_.CHPROP" everything "" "_color" "ByLAyer" "")
	(command "_.CHPROP" everything "" "_ltype" "ByLAyer" "")
	(command "_.CHPROP" everything "" "_lweight" "ByLAyer" "")
)

(defun C:Cleannn ()
	(c:nburst);from upgraded burst by Lee Mac
	(removewipeouts)
	(okill)
	(ZeroZ)
	(allbylayer)
	(princ)
)