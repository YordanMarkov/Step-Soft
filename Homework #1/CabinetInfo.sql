SELECT p.[Cabinet],
	   p.[Name] as "Patient",
	   p.[Date] as "Appointment"
FROM dbo.Patient p
JOIN dbo.Doctor d ON d.PatientID = p.ID;