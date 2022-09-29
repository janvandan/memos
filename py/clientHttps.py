import http.client

# https://docs.python.org/3/library/http.client.html

try:
  conn = http.client.HTTPSConnection("www.python.org")
  conn.request("GET", "/")
  
  r1 = conn.getresponse()

  print("status =", r1.status, "reason =", r1.reason)

  data1 = r1.read()  # This will return entire content.

  print( "data = ", data1)

except:
  print("Connexion erreur")
