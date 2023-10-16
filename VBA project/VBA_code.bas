Attribute VB_Name = "Module1"
Option Explicit

Public Function Calka_Ralstona(t0 As Double, tmax As Double, S0 As Double, I0 As Double, R0 As Double, beta As Double, gamma As Double, N As Long) As Double()


Dim tY() As Double
Dim i As Long
Dim h As Double
Dim kS1, kI1 As Double
Dim kS2, kI2 As Double
Dim NL As Double
Dim SN As Double
Dim IEN As Double
Dim RN As Double
NL = S0 + R0 + I0
h = (tmax - t0) / N

ReDim tY(1 To N + 1, 1 To 4)
tY(1, 1) = t0
tY(1, 2) = S0
tY(1, 3) = I0
tY(1, 4) = R0

For i = 2 To N + 1

tY(i, 1) = tY(i - 1, 1) + h
kS1 = (-beta / NL) * (tY(i - 1, 2) * tY(i - 1, 3))
kI1 = (beta / NL) * (tY(i - 1, 2) * tY(i - 1, 3) - gamma * tY(i - 1, 3))
kS2 = (-beta / NL) * (tY(i - 1, 2) + (h * 3 * kS1) / 4) * (tY(i - 1, 3) + (h * 3 * kI1) / 4)
kI2 = (beta / NL) * ((tY(i - 1, 2) + (h * kS1 * 3) / 4)) * (tY(i - 1, 3) + (h * kI1 * 3) / 4) - gamma * (tY(i - 1, 3) + (h * 3 * kI1) / 4)

SN = tY(i - 1, 2) + (h) * ((kS1 / 3) + 2 * (kS2 / 3))
IEN = tY(i - 1, 3) + (h) * ((kI1 / 3) + 2 * (kI2 / 3))
RN = NL - SN - IEN
tY(i, 2) = SN
tY(i, 3) = IEN
tY(i, 4) = RN
Next i

Calka_Ralstona = tY
End Function

Public Function Calka_RungeKutta3(t0 As Double, tmax As Double, S0 As Double, I0 As Double, R0 As Double, beta As Double, gamma As Double, N As Long) As Double()


Dim tY() As Double
Dim i As Long
Dim h As Double
Dim kS1, kI1 As Double
Dim kS2, kI2 As Double
Dim kS3, kI3 As Double
Dim NL As Double
Dim SN As Double
Dim IEN As Double
Dim RN As Double
NL = S0 + R0 + I0
h = (tmax - t0) / N

ReDim tY(1 To N + 1, 1 To 4)
tY(1, 1) = t0
tY(1, 2) = S0
tY(1, 3) = I0
tY(1, 4) = R0

For i = 2 To N + 1

tY(i, 1) = tY(i - 1, 1) + h

kS1 = (-beta / NL) * (tY(i - 1, 2) * tY(i - 1, 3))
kI1 = (beta / NL) * (tY(i - 1, 2) * tY(i - 1, 3) - gamma * tY(i - 1, 3))
kS2 = (-beta / NL) * (tY(i - 1, 2) + (h * kS1) / 2) * (tY(i - 1, 3) + (h * kI1) / 2)
kI2 = (beta / NL) * ((tY(i - 1, 2) + (h * kS1) / 2)) * (tY(i - 1, 3) + (h * kI1) / 2) - gamma * (tY(i - 1, 3) + (h * kI1) / 2)
kS3 = (-beta / NL) * (tY(i - 1, 2) - (h * kS1) + 2 * (h * kS2)) * (tY(i - 1, 3) - (h * kI1) + (h * kI2))
kI3 = (beta / NL) * (tY(i - 1, 2) - (h * kS1) + 2 * (h * kS2)) * (tY(i - 1, 3) - (h * kI1) + (h * kI2)) - gamma * (tY(i - 1, 3) + (h * kI1) / 2)

SN = tY(i - 1, 2) + (h / 6) * (kS1 + 4 * kS2 + kS3)
IEN = tY(i - 1, 3) + (h / 6) * (kI1 + 4 * kI2 + kI3)
RN = NL - SN - IEN
tY(i, 2) = SN
tY(i, 3) = IEN
tY(i, 4) = RN
Next i

Calka_RungeKutta3 = tY
End Function


