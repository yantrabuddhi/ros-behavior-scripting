(use-modules (srfi srfi-1) )

;(add-to-load-path "/usr/local/share/opencog/scm")
;(use-modules (opencog))
;(use-modules (opencog opencog exec))
;(use-modules (opencog openpsi))

(define timer-list '())

(define (clear-timers) (set! timer-list '()))

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

