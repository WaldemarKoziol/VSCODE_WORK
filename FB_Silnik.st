FUNCTION_BLOCK FB_Silnik
VAR_INPUT
    xPotwierdzenie: BOOL;   // styk pomocniczy stycznika (TRUE = stycznik zalaczony)
    xReset        : BOOL;   // kasowanie awarii
END_VAR
VAR_OUTPUT
    xSilnik : BOOL;   // wyjscie na stycznik silnika
    xAwaria : BOOL;   // brak potwierdzenia stycznika
END_VAR
VAR
    rtStart : R_TRIG; // zbocze narastajace przycisku START
    rtReset : R_TRIG; // zbocze narastajace przycisku RESET
    tonPotw : TON;    // czas oczekiwania na potwierdzenie stycznika
END_VAR

rtStart(CLK := xStart);
rtReset(CLK := xReset);

// Kasowanie awarii zboczem - trzymany RESET nie maskuje kolejnej awarii
IF rtReset.Q THEN
    xAwaria := FALSE;
END_IF

// Kontrola potwierdzenia: silnik zalaczony, a brak potwierdzenia przez 2 s
// (dotyczy zarowno rozruchu, jak i utraty potwierdzenia w trakcie pracy)
tonPotw(IN := xSilnik AND NOT xPotwierdzenie, PT := T#2S);
IF tonPotw.Q THEN
    xAwaria := TRUE;
END_IF

// Logika samopodtrzymania: STOP, E-STOP i awaria maja pierwszenstwo
// START tylko zboczem - wcisniety/zablokowany START nie uruchomi silnika ponownie
IF NOT xEStop OR NOT xStop OR xAwaria THEN
    xSilnik := FALSE;
ELSIF rtStart.Q THEN
    xSilnik := TRUE;
END_IF

END_FUNCTION_BLOCK
