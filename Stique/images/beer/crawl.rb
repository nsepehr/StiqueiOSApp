require 'open-uri'
require 'nokogiri'
require 'json'

out = []
(1..20).each do |i|
	html = `curl 'http://www.bevmo.com/beer-cider/craft-brew.html?mode=list&is_ajax=1&p=#{i}&is_scroll=1' -H 'Cookie: liveagent_oref=https://www.google.com/; liveagent_sid=cbe956c0-24b3-48b3-85ac-390e62205d9c; liveagent_vc=2; liveagent_ptid=cbe956c0-24b3-48b3-85ac-390e62205d9c; agegate=vpZaeHMwV6pTGrGkCgYTQw4R; addshoppers.com=2%7C1%3A0%7C10%3A1457052936%7C15%3Aaddshoppers.com%7C44%3AMmQ0MmZlNGFiOWI4NGQxZmI4MzU5NTJjMDYwODk3NzA%3D%7Ca31289da906e9c1f958fd08b946292fd79fe1e58755ca0cd9efbccc9ea4ee5c7; frontend=rgtja1lk2epp81c8gotsffulh6; LOCATION_ID=14; SLICARTCOUNT=0; SLICARTTOTAL=0.00; SLILOCATION=store=Pleasanton&state=California&id=14; SLIFULFILLMENT=method=shipping&zip=; _ga=GA1.2.1395923190.1457052934; _gat=1' -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,fa;q=0.6' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36' -H 'Accept: text/javascript, text/html, application/xml, text/xml, */*' -H 'Referer: http://www.bevmo.com/beer-cider/craft-brew.html?mode=list' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'X-Prototype-Version: 1.7' --compressed`
	# html = open('/tmp/a.html').read
  json = JSON.parse(html)
  doc = Nokogiri::HTML(json['page'])
  out += doc.css('li.item').map do |row|
  	{
	  	url: row.css('img').attr('src').value,
	  	name: row.css('.product-name').text,
	  	price: row.css('.price-box').children[1].css('.price').text.strip,
	  }
  end
end
puts out.to_json
