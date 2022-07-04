SELECT p.[Name] as "Patient",
	   d.[Name] as "Doctor",
	   p.[Cabinet],
	   p.[Date] as "Appointment",
	   p.[Diagnosis],
	   d.[Prescription] as "Prescription"
FROM dbo.Patient p
JOIN dbo.Doctor d ON d.PatientID = p.ID;