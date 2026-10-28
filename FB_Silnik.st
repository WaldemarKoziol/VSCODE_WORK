FUNCTION_BLOCK FB_Silnik
VAR_INPUT
    xStart  : BOOL;   // przycisk START (NO)
    xStop   : BOOL;   // przycisk STOP (NC: TRUE = nie wcisniety)
    xEStop  : BOOL;   // obwod bezpieczenstwa OK (TRUE = zamkniety)
END_VAR
VAR_OUTPUT
    xSilnik : BOOL;   // wyjscie na stycznik silnika
END_VAR

// Logika samopodtrzymania: STOP i E-STOP maja pierwszenstwo
IF NOT xEStop OR NOT xStop THEN
    xSilnik := FALSE;
ELSIF xStart THEN
    xSilnik := TRUE;
END_IF

END_FUNCTION_BLOCK