SELECT * FROM offenders;

SELECT * FROM offenders
WHERE gender = 'M';

SELECT * FROM crimes
WHERE offense = 'Bulglary'
ORDER BY id DESC, crimeDate DESC;