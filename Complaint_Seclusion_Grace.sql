

SELECT  
	CF.DBHDSID
	--, IP.IndividualPHIKey
	, PHI.LastName
	, PHI.FirstName
	, CONVERT(DATE,PHI.BirthDate) Birth 
	, PHI.GenderDescription
	, D4.Date EnterDate
	, PO.ProviderOrganizationFullName
	, CF.Description
	, CT.CategoryValue
	, CT.SubcategoryValue

	
FROM fact.ComplaintFact CF
	JOIN dim.[Date] D					ON CF.IncidentDateKey = D.DateKey
	JOIN dim.Date D4					ON CF.EnterDateKey = D4.DateKey
	JOIN dim.Date D5					ON CF.CloseDateKey = D5.DateKey
	JOIN dim.ComplaintType CT			ON CF.COmplaintTypeKey = CT.ComplaintTypeKey
	JOIN dim.ProviderOrganization PO	ON CF.ProviderOrganizationKey = PO.ProviderOrganizationKey
	JOIN dim.IndividualPHI IP			ON CF.IndividualPHIKey = IP.IndividualPHIKey
	left join   
	(
		select DBHDSID
			, BirthDate 
			, GenderDescription
			, FirstName
			, LastName
			, ROW_NUMBER() over (partition by DBHDSID order by COALESCE(EndEffectiveDate, GETDATE()) desc) as RowNumber
			from  dim.IndividualPHI
	) PHI  on IP.DBHDSID = PHI.DBHDSID 
			and PHI.RowNumber = 1       
	JOIN dim.IncidentServiceType IST	ON CF.IncidentServiceTypeKey = IST.IncidentServiceTypeKey
	
	
WHERE 
	D.FiscalYear = 2017
	AND IST.ServiceTypeID in(3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,39,40,41,42,43)
	AND (CF.Description like '%isol%'
	or CF.Description	like '%seclu%'
	or CF.Description	like '%lock%'
	or CF.Description	like '%time-out%')

ORDER BY 
PHI.LastName
, PHI.FirstName


;



Select COUNT(cf.ComplaintID) as incidents

FROM fact.ComplaintFact CF
	JOIN dim.IncidentServiceType IST	ON CF.IncidentServiceTypeKey = IST.IncidentServiceTypeKey
	JOIN dim.[Date] D					ON CF.IncidentDateKey = D.DateKey
	JOIN dim.IndividualPHI PHI			ON CF.IndividualPHIKey = PHI.IndividualPHIKey
		and PHI.RecordDeleted = 0
		and PHI.EndEffectiveDate is null

	
WHERE 
	D.FiscalYear = 2017
	AND IST.ServiceTypeID in(3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,39,40,41,42,43)
	AND (CF.Description like '%isol%'
	or CF.Description	like '%seclu%'
	or CF.Description	like '%lock%'
	or CF.Description	like '%time-out%')


Select *
FROM dim.IndividualPHI
Where DBHDSID = '645809'