## GeoWatch – Project Overview

GeoWatch is a real-time crowd safety monitoring platform designed for large public events.  
Participants report incidents through a mobile application, while administrators monitor evolving risk zones through a live dashboard.

The system transforms raw incident reports into **geospatial clusters and risk levels**, allowing organizers to quickly identify dangerous crowd areas and respond faster.

---

## Core Idea

Large events often generate scattered incident reports that are difficult to interpret individually.  
GeoWatch aggregates these reports and applies **geospatial clustering** to detect emerging risk zones in real time.

---

## Key Features

- **Real-Time Incident Reporting**
  - Participants submit SOS alerts with live GPS coordinates.

- **Event Geofencing**
  - Incidents are validated to ensure they occur inside the event boundary.

- **Risk Zone Detection**
  - DBSCAN clustering groups nearby incidents into clusters.

- **Risk Classification**
  - Clusters are categorized as **LOW, MEDIUM, or HIGH risk**.

- **Live Dashboard**
  - Admins monitor safety zones through a map-based interface.

- **WebSocket Updates**
  - Incident clusters update instantly without refreshing the dashboard.

---

## System Components

| Component | Description |
|----------|-------------|
| **Mobile App** | Flutter application used by participants to report incidents |
| **Backend API** | Spring Boot service handling incident ingestion, clustering, and broadcasting |
| **Admin Dashboard** | React web application for monitoring crowd safety in real time |
| **Database** | PostgreSQL storing events, incidents, organizers, and admins |
| **Realtime Engine** | WebSocket + STOMP broadcasting cluster updates |

---

## How the System Works

1. Participants discover nearby events using GPS.
2. A participant submits an **SOS incident report**.
3. The backend validates the report and stores it in the database.
4. The system recalculates **incident clusters using DBSCAN**.
5. Updated risk zones are pushed to the admin dashboard via **WebSockets**.
6. Organizers see **live heatmaps and cluster markers** on the event map.

---

## Technologies Used

| Layer | Technology |
|------|-------------|
| Mobile | Flutter |
| Frontend | React + TypeScript |
| Backend | Spring Boot |
| Database | PostgreSQL |
| Mapping | Leaflet |
| Realtime Communication | WebSocket + STOMP |
| Clustering Algorithm | DBSCAN |
| Geospatial Calculations | Haversine Formula |

---

## What GeoWatch Achieves

GeoWatch converts scattered incident reports into **real-time geospatial risk intelligence**, helping event organizers detect danger zones early and improve crowd safety response.# Aarohan-26-CSI-RAIT-Runtime-Sync