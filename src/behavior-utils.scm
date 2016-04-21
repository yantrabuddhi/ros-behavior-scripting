(use-modules (srfi srfi-1) )

(add-to-load-path "/usr/local/share/opencog/scm")
(use-modules (opencog))
(use-modules (opencog exec))
;(use-modules (opencog openpsi))

(define timer-list '())

(define (clear-timers) (set! timer-list '()))

;(define (get-timer-info id) (filter (lambda (x)(string=? id (car x))) timer-list))

;(define (remove-timer id) (set! timer-list (filter (lambda (x)(not (string=? id (car x)))) timer-list) ))

(define (get-timer-info id) (filter (lambda (x)(= id (car x))) timer-list))

(define (remove-timer id) (set! timer-list (filter (lambda (x)(not (= id (car x)))) timer-list) ))

(define (timer-exists id) (> (length (get-timer-info id)) 0) )

;elps is pair of seconds and microseconds
(define (set-timer id elps) (if (not (timer-exists id)) (set! timer-list (append timer-list (list(list id elps (gettimeofday))))) (display "timer already exists")) )

(define (peek-timer id) (let ((tmr (get-timer-info id)))(if (= 1 (length tmr)) 
							(let* ( (tm (cdr (car tmr))) (elp (car tm)) (st (car (cdr tm))) 
								(el-sec (car elp)) (el-ms (cdr elp)) (st-sec (car st)) (st-ms (cdr st))
								(ct (gettimeofday)) (ct-sec (car ct)) (ct-ms (cdr ct))
								(pt-sec (- ct-sec st-sec)) (pt-ms (- ct-ms st-ms))
								)
								(if (> pt-sec el-sec) #t (and (= pt-sec el-sec) (> pt-ms el-ms) ) )
							)
							#f))
)


;;
;;
;; Helper Functions
;(define (set-timer-sec-ms id secs msec) ((set-timer id (cons secs msec))(stv 1 1)) ) 
(define num-v-list '())

(define (add-num-v)
	(set! num-v-list (append num-v-list '(0)))
	(length num-v-list)
)

;(define (node2num node) (cog-name node))

;(define (get-num-var v-id)
;	(NumberNode (list-ref num-v-list (- (node2num v-id) 1)))
;)

;(define (reset-num-var v-id) (list-set! num-v-list (-(node2num v-id) 1) 0)
;)

;(define (set-num-var v-id)
;	(list-set! num-v-list (-(node2num v-id) 1) 1)
;)

;(define (make-number-variable v-name)
;	(let ((v-id (add-num-v)))(
;		(DefineLink
;			(DefinedSchemaNode (string-append "num-var:" v-name))
;			(NumberNode v-id)
;		)
;		(DefineLink
;			(DefinedSchemaNode (string-append "get-num-var:" v-name))
;			(ExecutionOutputLink
;				(GroundedSchemaNode ("scm: get-num-var"))
;				(ListLink (DefinedSchemaNode (string-append "num-var:" v-name)))
;			)
;		)
;		(DefineLink
;			(DefinedPredicateNode (string-append "reset-num-var:" v-name))
;			(EvaluationLink
;				(GroundedPredicateNode ("scm: reset-num-var"))
;				(ListLink (DefinedSchemaNode (string-append "num-var:" v-name)))
;			)
;		)
;		(DefineLink
;			(DefinedPredicateNode (string-append "set-num-var:" v-name))
;			(EvaluationLink
;				(GroundedPredicateNode ("scm: set-num-var"))
;				(ListLink (DefinedSchemaNode (string-append "num-var:" v-name)))
;			)
;		)
;	v-id
;	)
;)


(define (node2num node) (numerator (inexact->exact(string->number (cog-name node)) )) )
;(define (node2num node) node)
;(define (node2num node) (cog-name node))
(define (get-num-var vid1)
	(if (> (list-ref num-v-list (- (node2num vid1) 1)) 0) (stv 1 1) (stv 0 1))
)

(define (reset-num-var vid1) (list-set! num-v-list (-(node2num vid1) 1) 0) (stv 1 1)
)

(define (set-num-var vid1)
	(list-set! num-v-list (- (node2num vid1) 1) 1) (stv 1 1)
)

(define (pred-2-schema pnode-str) 
	(DefineLink 
		(DefinedSchemaNode pnode-str)
		(ExecutionOutputLink (GroundedSchemaNode "scm: cog-evaluate!")
			(ListLink (DefinedPredicateNode pnode-str))
)))
(define v-id 0)
(define (make-number-variable v-name)
		(set! v-id (add-num-v))
		(DefineLink
			(DefinedSchemaNode (string-append "num-var:" v-name))
			(NumberNode v-id)
		)
		(DefineLink
			(DefinedPredicateNode (string-append "get-num-var:" v-name))
			(EvaluationLink
				(GroundedPredicateNode "scm: get-num-var")
				(ListLink (NumberNode v-id))
			)
		)
		(DefineLink
			(DefinedPredicateNode (string-append "reset-num-var:" v-name))
			(EvaluationLink
				(GroundedPredicateNode "scm: reset-num-var")
				(ListLink (NumberNode v-id))
			)
		)
		(DefineLink
			(DefinedPredicateNode (string-append "set-num-var:" v-name))
			(EvaluationLink
				(GroundedPredicateNode "scm: set-num-var")
				(ListLink (NumberNode v-id))
			)
		)
		(pred-2-schema (string-append "reset-num-var:" v-name))
		(pred-2-schema (string-append "set-num-var:" v-name))
	  	v-id
)
;(define (make-number-variable v-name)
;	(let ((v-id (add-num-v)))(
;		(DefineLink
;			(DefinedSchemaNode (string-append "num-var:" v-name))
;			(NumberNode v-id)
;		)
;		(DefineLink
;			(DefinedPredicateNode (string-append "get-num-var:" v-name))
;			(EvaluationLink
;				(GroundedPredicateNode "scm: get-num-var")
;				(ListLink (NumberNode v-id))
;			)
;		)
;		(DefineLink
;			(DefinedPredicateNode (string-append "reset-num-var:" v-name))
;			(EvaluationLink
;				(GroundedPredicateNode "scm: reset-num-var")
;				(ListLink (NumberNode v-id))
;			)
;		)
;		(DefineLink
;			(DefinedPredicateNode (string-append "set-num-var:" v-name))
;			(EvaluationLink
;				(GroundedPredicateNode "scm: set-num-var")
;				(ListLink (NumberNode v-id))
;			)
;		)
;		(pred-2-schema (string-append "reset-num-var:" v-name))
;		(pred-2-schema (string-append "set-num-var:" v-name))
;	  	v-id)
;	)
;)

(define (declare-timer timer-name timer-id)
	(DefineLink
		(DefinedSchemaNode (string-append "timer:" timer-name))
		(NumberNode timer-id)
	)
)

;;
;;
;;(define (declare-psi-timer timer-name)
;;)


