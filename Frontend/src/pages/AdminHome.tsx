import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { getActiveEvents } from '../services/api'

function AdminHome() {
  const navigate = useNavigate()
  const [events, setEvents] = useState<Array<{ id: string | number }>>([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    const loadEvents = async () => {
      try {
        const data = await getActiveEvents()
        if (Array.isArray(data)) {
          setEvents(data)
        } else {
          setEvents([])
        }
      } catch {
        console.error('Failed to fetch events')
        setEvents([])
      } finally {
        setLoading(false)
      }
    }

    void loadEvents()
  }, [])

  const handleViewExistingEvent = () => {
    if (events.length === 0) {
      return
    }

    navigate(`/admin/dashboard/${events[0].id}`)
  }

  return (
    <section className="mx-auto flex min-h-[70vh] w-full max-w-md items-center justify-center">
      <div className="w-full rounded-xl bg-slate-800 p-8 text-center shadow-sm">
        <h1 className="text-3xl font-bold">GeoWatch</h1>
        <p className="mt-2 text-slate-300">Admin Panel</p>

        <div className="mt-8 space-y-3">
          <button
            type="button"
            onClick={() => navigate('/admin/create-event')}
            className="w-full rounded-lg bg-cyan-400 px-4 py-3 text-sm font-semibold text-slate-900 transition hover:bg-cyan-300"
          >
            Create New Event
          </button>

          <button
            type="button"
            onClick={handleViewExistingEvent}
            disabled={loading || events.length === 0}
            className="w-full rounded-lg border border-slate-500 bg-slate-900 px-4 py-3 text-sm font-semibold text-slate-100 transition hover:border-cyan-400"
          >
            View Existing Event
          </button>
        </div>

        {!loading && events.length === 0 && (
          <p className="mt-4 text-sm text-rose-300">No existing event found. Please create an event first.</p>
        )}
      </div>
    </section>
  )
}

export default AdminHome
