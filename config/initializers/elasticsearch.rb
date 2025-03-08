Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: "http://localhost:9200",
  user: "elastic",
  password: "k3BvUoBlU=A+E*R0V5Zw",
  transport_options: {
    headers: { content_type: "application/json" }
  }
)
