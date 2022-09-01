#include "math.h"

#include "WolframRTL.h"

static WolframCompileLibrary_Functions funStructCompile;

static mint I0_0;

static mint I0_1;

static mint I0_2;

static mreal R0_8;

static mreal R0_9;

static mcomplex C0_0;

static mbool initialize = 1;

#include "fun.h"

DLLEXPORT int Initialize_fun(WolframLibraryData libData)
{
if( initialize)
{
funStructCompile = libData->compileLibraryFunctions;
mcreal(C0_0) = 0.;
mcimag(C0_0) = 1.;
R0_9 = (mreal) 3.141592653589793;
I0_2 = (mint) 2;
I0_1 = (mint) 1;
I0_0 = (mint) 3;
R0_8 = (mreal) 0.;
initialize = 0;
}
return 0;
}

DLLEXPORT void Uninitialize_fun(WolframLibraryData libData)
{
if( !initialize)
{
initialize = 1;
}
}

DLLEXPORT int fun(WolframLibraryData libData, mreal A1, mreal A2, mreal A3, mcomplex *Res)
{
mreal R0_0;
mreal R0_1;
mreal R0_2;
mreal R0_3;
mreal R0_4;
mreal R0_5;
mreal R0_6;
mreal R0_7;
mreal R0_10;
mcomplex C0_1;
mcomplex C0_2;
mcomplex C0_3;
int err = 0;
R0_0 = A1;
R0_1 = A2;
R0_2 = A3;
R0_3 = (mreal) I0_0;
R0_4 = 1 / R0_3;
R0_3 = R0_4;
R0_5 = -R0_1;
R0_5 = R0_5 * R0_2;
R0_6 = (mreal) I0_0;
R0_7 = sqrt(R0_6);
mcreal(C0_1) = R0_7;
mcimag(C0_1) = R0_8;
{
mreal S0 = mcreal(C0_0);
mreal S1 = mcimag(C0_0);
mreal S2 = mcreal(C0_1);
mreal S3 = mcimag(C0_1);
mcreal(C0_2) = S0 * S2 - S1 * S3;
mcimag(C0_2) = S0 * S3 + S1 * S2;
}
R0_7 = (mreal) I0_1;
mcreal(C0_1) = R0_7;
mcimag(C0_1) = R0_8;
mcreal(C0_1) = mcreal(C0_1) + mcreal(C0_2);
mcimag(C0_1) = mcimag(C0_1) + mcimag(C0_2);
R0_6 = -R0_9;
if( I0_0 == 0)
{
if( R0_1 == 0)
{
err = 1;
goto error_label;
}
else
{
R0_7 = 1;
}
}
else
{
mint S0 = I0_0;
mreal S1 = R0_1;
mbool S2 = 0;
if( S0 < 0)
{
S2 = 1;
S0 = -S0;
}
R0_7 = 1;
while( S0)
{
if( S0 & 1)
{
R0_7 = S1 * R0_7;
}
S1 = S1 * S1;
S0 = S0 >> 1;
}
if( S2)
{
R0_7 = 1 / R0_7;
}
}
if( I0_0 == 0)
{
if( R0_2 == 0)
{
err = 1;
goto error_label;
}
else
{
R0_10 = 1;
}
}
else
{
mint S0 = I0_0;
mreal S1 = R0_2;
mbool S2 = 0;
if( S0 < 0)
{
S2 = 1;
S0 = -S0;
}
R0_10 = 1;
while( S0)
{
if( S0 & 1)
{
R0_10 = S1 * R0_10;
}
S1 = S1 * S1;
S0 = S0 >> 1;
}
if( S2)
{
R0_10 = 1 / R0_10;
}
}
R0_6 = R0_6 * R0_7 * R0_10;
R0_7 = R0_2 * R0_2;
R0_10 = (mreal) I0_0;
R0_10 = R0_10 * R0_7 * R0_0;
R0_7 = -R0_10;
R0_6 = R0_6 + R0_7;
R0_7 = pow(R0_6, R0_3);
R0_6 = pow(R0_9, R0_3);
R0_10 = (mreal) I0_2;
R0_10 = R0_10 * R0_6;
R0_6 = 1 / R0_10;
mcreal(C0_2) = R0_7;
mcimag(C0_2) = R0_8;
mcreal(C0_3) = R0_6;
mcimag(C0_3) = R0_8;
{
mreal S0 = mcreal(C0_1);
mreal S1 = mcimag(C0_1);
mreal S2 = mcreal(C0_2);
mreal S3 = mcimag(C0_2);
mcreal(C0_1) = S0 * S2 - S1 * S3;
mcimag(C0_1) = S0 * S3 + S1 * S2;
}
{
mreal S0 = mcreal(C0_1);
mreal S1 = mcimag(C0_1);
mreal S2 = mcreal(C0_3);
mreal S3 = mcimag(C0_3);
mcreal(C0_1) = S0 * S2 - S1 * S3;
mcimag(C0_1) = S0 * S3 + S1 * S2;
}
mcreal(C0_2) = R0_5;
mcimag(C0_2) = R0_8;
mcreal(C0_2) = mcreal(C0_2) + mcreal(C0_1);
mcimag(C0_2) = mcimag(C0_2) + mcimag(C0_1);
*Res = C0_2;
error_label:
funStructCompile->WolframLibraryData_cleanUp(libData, 1);
return err;
}

