export interface Cluster {
  id: string
  latitude: number
  longitude: number
  severity: 'LOW' | 'MEDIUM' | 'HIGH'
  reportCount: number
}
