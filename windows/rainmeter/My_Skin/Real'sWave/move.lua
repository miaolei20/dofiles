function Initialize()
	SeO='!SetOption'
	Lnum=90
	K=0
	Wave()
	Band = {} for i = 1,Lnum do Band[i]=0 end
	BandV = 0
end

function Update()

	BandValue()
	Line()

end

function BandValue( ... )
	for i = 1,Lnum do
		Band[i]=(SKIN:GetMeasure('Band'..i)):GetValue()
	end
end

function Line( ... )
		K= K+1
		Kl = math.pi/3000*math.fmod(K,3000)*2
		if K == 3000 then K = 0 end
		for i = 1,Lnum do

			SKIN:Bang(SeO, 'Line'..i, 'MeterStyle' ,'LineStyle')
			SKIN:Bang(SeO, 'Line'..i, 'StartAngle' ,(math.pi/Lnum*(i-1)*2-Kl))
			SKIN:Bang(SeO, 'Line'..i, 'LineWidth' ,'8')
			SKIN:Bang(SeO, 'Line'..i, 'LineStart' ,(138+Band[i]*110))
			SKIN:Bang(SeO, 'Line'..i, 'LineLength' ,(145+Band[i]*110))
			SKIN:Bang(SeO, 'Line'..i, 'LineColor' ,'#Line#,'..(Band[i]*300))

			SKIN:Bang(SeO, 'LineC'..i, 'MeterStyle' ,'LineStyle')
			SKIN:Bang(SeO, 'LineC'..i, 'StartAngle' ,(math.pi/Lnum*(i-1)*2+Kl))
			SKIN:Bang(SeO, 'LineC'..i, 'LineStart' ,(132-Band[i]*30))
			SKIN:Bang(SeO, 'LineC'..i, 'LineLength' ,'137')
			SKIN:Bang(SeO, 'LineC'..i, 'LineColor' ,'#Line#,'..(100+Band[i]*200))

		end
end

function Wave( ... )
	for i = 1,Lnum do
		SKIN:Bang(SeO, 'Band'..i, 'Type' ,'Band')
		--SKIN:Bang(SeO, 'Band'..i, 'BandIdx' ,(i+60))
	end
	for i = 1,(Lnum/2) do
		SKIN:Bang(SeO, 'Band'..i, 'Channel' ,'R')
		SKIN:Bang(SeO, 'Band'..i, 'BandIdx' ,(i))
	end
	for i = (Lnum/2+1),Lnum do
		SKIN:Bang(SeO, 'Band'..i, 'Channel' ,'L')
		SKIN:Bang(SeO, 'Band'..i, 'BandIdx' ,(i-Lnum/2))
		--SKIN:Bang(SeO, 'Band'..i, 'BandIdx' ,(91-i))
	end
end