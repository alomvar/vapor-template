import Vapor

let app = Application()

app.get("/") { request in
	return try app.view("index.html")
}

print("Visit http://localhost:8080")
app.start(port: 8080)
