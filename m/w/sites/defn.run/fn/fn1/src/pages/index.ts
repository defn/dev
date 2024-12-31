export async function GET() {
  return new Response(JSON.stringify({ hello: "worldx" }), {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
  });
}
