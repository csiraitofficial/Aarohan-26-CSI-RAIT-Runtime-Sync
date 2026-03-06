import { useParams } from 'react-router-dom'

function Dashboard() {
  const { eventId } = useParams()

  return (
    <section className="rounded-xl bg-slate-800 p-8 shadow-sm">
      <h1 className="text-3xl font-bold">GeoWatch</h1>
      <p className="mt-2 text-slate-300">Dashboard for event: {eventId}</p>
    </section>
  )
}

export default Dashboard
