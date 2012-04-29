#!/usr/bin/env ruby19 -KU
require "Nokogiri"

(puts "#{File.basename $0} path"; exit) if ARGV.length ==0
lines = IO.readlines File.expand_path ARGV[0]

IMAGE_DATA=%{
		/9j/4AAQSkZJRgABAQAAAQABAAD/4QBYRXhpZgAATU0AKgAAAAgAAgESAAMA
		AAABAAEAAIdpAAQAAAABAAAAJgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAAB
		AAAAcqADAAQAAAABAAAAcgAAAAD/2wBDACAWGBwYFCAcGhwkIiAmMFA0MCws
		MGJGSjpQdGZ6eHJmcG6AkLicgIiuim5woNqirr7EztDOfJri8uDI8LjKzsb/
		2wBDASIkJDAqMF40NF7GhHCExsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbG
		xsbGxsbGxsbGxsbGxsbGxsbGxsbGxsb/wAARCAByAHIDASIAAhEBAxEB/8QA
		HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
		BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
		FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
		dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
		x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
		AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
		AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
		JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
		hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
		1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDXoooqCgoo
		ooAKKZMjSRMiuUY9GHamW0xkUpINsqcMP60BbQmoo6U0v6U0m9hNpbikhRkk
		Ae9LVB2+2zhcf6PEeT/farwYetHKwuhaKKKQwooooAKKKKAFpKKKACimSypC
		u6RtorPS8Wf5/IkmJJwMfKo7UWA0DNEOsqD/AIEKgnKyESQOvmp0IOQR6GoT
		JdyDCpDAvp1NN+yhzmV2c+wC/wAqtQJckupKL2Ij96wjYdVaonn+0KRG/lxd
		GkJx+AqOCKAq8TqgeM4bIAyOxpLa3ilDyJwu4hcccDvV67E+7e5bjkjRQkaP
		tA4whxTvPjH3iV/3lIqDyGH3Z5l/4Fn+dJtu1+7cI/s609SbRZcByMg07cfW
		sqC5lguTbMgOWBwvRc/0rVRC5wvT1ounuJpp6ChieMZp9O+SFcdWP5mm1lK3
		Q0jfqFFFFSWFIWA60jMfMVB1bPP0prI46jP0qoxvuRJtbEF2iXCbJUyoOQM1
		WTfboI1UvGOmOo/xq5jNG0VtyroZ8z6lYTrjmOX6bDSiZ24SJh7vx+lWcUmK
		LCuuxT+xwuS0ib3JyWNPWIw58jCqedhGRn29Ks4oxRZBzMr75/8AngD776Q/
		aG/hRB65yatAZOAMmp0iCfM/J/QUm7FLXoV7W0KjLZAJyfVvrVlpQrCKMAv6
		elVp7xnk8i2G5zxn0qUCOygLyNuY/ebux9KzbNFFjyu08nJPUmismPUXNw0h
		Xfu4Az/KtSNiyAspUn+EnpUPuVa2g78KKKKAGOG3o6gErng+9O+0x79jHY3o
		aU9DVS0tIbu2WaZd0jZy2eetNMLdS9hXHY00wKehIqt/Z7RnMFw6+zcinqby
		P76LIPVTzVJkuI5oXHTB+lMII6gj61KtyvR1ZD7iplZXHBBquZkOCKlKqFzg
		fnVhoUPbH0qG4uI7ZOfwApufYSgPJSBCScepNZs95Jcv5cIIUnHHU1BNNJdP
		83TsorUsrQW6eZJjeRz/ALIrK99jqUFBXl9wttbx2UBdyN2Ms1ZNzNNqNz5U
		KkgdvQe9XZvN1GTZESkCn7x7+9WlS2022PREHUnqx/qaETJtb7kdrZQ2MRdy
		C4HLnoPpUyMHUMpyDyDVPL3x824BjtlOVj7t9atoSy527R2FJtMm2g6iiigC
		C+Z1tHMbFW45Hbmm2wms4zH5bTIDkOpGcfSpLpd9rKvcqQPrUFtqsBAimJik
		Awd44J+tNBexbS9gY4LbG9HGKnDBhlSCPaoyscqchXU/jVWTTVzut5Xhb8xT
		1D3WXiBUbQo3O3B9RxWa8mqWmSyCdB3Xn/69JFrsZOJYyp9qLhy32NIpIBhZ
		Dj3GazZtOuGcuWEh+uKuxahbS/dlA+vFWVZWGVII9qHqOLcHexSsLLyv3so+
		fsPSlmc3kpgjOIl/1jDv7U66maWT7NAfmP32/uioZ7uOxRbe3XzJuy+nuaRT
		bvzPcsXN1DYwqCOcYSNepqlFDJdyfabw4VeiDov/ANem2tqzyNPcPuf+Jj29
		hVwDziOMRL0HrUOV9gUbasVR5pDEYQfdWpaKKaViW7hRRRTEQ3AOVJyV6ECo
		GtYZlwCGHoau01o0bqoz61LVylKxmfYprZt1rK8ft1BqRNUng4u4Mr/fj/wq
		6UdfuPn2amMR/wAtY8e4ou0FkyW3vbe5H7qVSfQ8H8qW4s7e5H72JWPr0P51
		Ql0+3nOUIDeq8GmKNRs/9XIJ0H8L9fzq1LuS49htzoOMtbSf8Bb/ABq1baas
		MYDyOz92DYpIdYiJ2XMbwP7jIqrc3kt+xitspB0Z+7UNq12Eea9kOluxEWtr
		D55CfnlPOKdZWYXJJyerue9OtLRVGxBhRyTVkAS/InES9T/erJvm9DXb1FA8
		3CqMRL0/2qm+lAAAwOAKKpKxm3cKKKKoQUUUUAFFFFABRRRQAx4kbqOfUUzy
		5F+4+R6NU1FKw7srSKrrtnh49eopI4I9oWIgAdvSrVMaJG6jn1FS43GpEZ/e
		fuo+Ix95v71TABQABwKFUKoAGAKWmlYTdwoooqhBRRRQAUUtFACUUUUAFFFF
		ABRRRQAUUUUAFFFFABQOtFFABRRRQAUUUUAf/9k=
		}

i=-1
builder = Nokogiri::XML::Builder.new do |xml|
	xml.dict{
		lines[1..-1].each do |line|
			author, date, title = line.split "\t"
			author.gsub! '"', ''
			fdate = Time.parse date 
			strdate = fdate.strftime '%e %B %Y'
			
			xml.key{ xml << "Novel#{i+=1}"}
			xml.dict{
					xml.key{    xml << "authorName"}
					xml.string{ xml << author.strip }	
					
					xml.key{    xml << "dateFinished" }
					xml.string{ xml << strdate}
					
					xml.key{    xml << "dateStarted" }
					xml.string{ xml << strdate}
					
					xml.key{ xml << "image"}
					xml.data{ xml << IMAGE_DATA}
					
					xml.key{    xml << "key" }
					xml.string{ xml << "Novel#{i}"}
					
					xml.key{    xml << "notes" }
					xml.string{ xml << ""}
					
					xml.key{    xml << "novelName" }
					xml.string{ xml << title.strip}
			}
		end
	}
end

out = %{<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">}

out << builder.to_xml.sub('<?xml version="1.0"?>', "")
out << "</plist>"
out.gsub! "  ", "\t"
puts out