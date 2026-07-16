#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Todos los Frentes Avanzan],
  authors: (
    (
      name: "Junio 2026",
      department: "Platform Engineering",
      institution: "",
      city: "Remoto",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "June",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "AWS MSK",
    "Kafka",
    "Harbor",
    "Backstage",
    "Cost Optimization",
    "Security",
    "Change Management",
  ),
  doi: "10.0000/fortris.platform.2026.06",
  abstract: [
    El registro de contenedores comenzó su migración a infraestructura
    propiedad de la plataforma. Clearing — un proveedor global regulado de
    infraestructura de pagos — empezó su incorporación tras una fusión. El
    portal de desarrollo tomó forma. La automatización de gestión de cambios
    sentó sus bases. Dos vulnerabilidades de seguridad se parchearon en días.
    Todo avanzando.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

#v(2mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[JUNIO 2026 — ESTADO DE INICIATIVAS]
  #v(4mm)
  #grid(
    columns: (1fr, auto, auto),
    gutter: 3mm,
    [#text(size: 7pt, weight: "bold", fill: gray)[Iniciativa]],
    [#text(size: 7pt, weight: "bold", fill: gray)[Estado]],
    [#text(size: 7pt, weight: "bold", fill: gray)[Qué se entregó]],

    [#text(size: 7pt, fill: gray)[HS Vault → K8s]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[AVANZANDO]],
    [#text(size: 6.5pt, fill: gray)[LDT migrado, PROD pendiente]],

    [#text(size: 7pt, fill: gray)[Harbor Registry]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[AVANZANDO]],
    [#text(size: 6.5pt, fill: gray)[Sincronizando, pipelines migrados]],

    [#text(size: 7pt, fill: gray)[Portal de Desarrollo]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[CIMIENTOS]],
    [#text(size: 6.5pt, fill: gray)[Autodescubrimiento, páginas de servicio]],

    [#text(size: 7pt, fill: gray)[Orquestador CHG]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[CIMIENTOS]],
    [#text(size: 6.5pt, fill: gray)[API desplegada, lógica completa]],

    [#text(size: 7pt, fill: gray)[Onboarding Clearing]],
    [#text(size: 6.5pt, weight: "bold", fill: gray)[INICIANDO]],
    [#text(size: 6.5pt, fill: gray)[GitLab, AWS bootstrap iniciado]],

    [#text(size: 7pt, fill: gray)[Respuesta de Seguridad]],
    [#text(size: 6.5pt, weight: "bold", fill: red)[HECHO]],
    [#text(size: 6.5pt, fill: gray)[2 CVEs parcheados en días]],
  )
]

#v(6mm)

= Todas las Imágenes de Contenedores se Mudan

Harbor — el registro que almacena cada imagen de contenedor de la empresa — está migrando de infraestructura legacy corporativa a AWS propiedad de la plataforma. Sin esto, una sola caída de Docker Hub o un límite de tasa podría paralizar cada despliegue en cada entorno.

La nueva instancia está activa en `registry.hub.codecraft.tools`. La replicación corre continuamente de la antigua a la nueva. Los runners de GitLab, los Helm charts, ArgoCD y TestContainers ya apuntan a la nueva fuente.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[PROGRESO DE MIGRACIÓN HARBOR]
  #v(3mm)
  #text(size: 6.5pt, fill: gray)[
    ● Nueva instancia activa — HA, Keycloak SSO, base de datos RDS, almacenamiento S3\
    ● Replicación activa — la instancia antigua empuja todo a la nueva\
    ● Runners de GitLab migrados a la nueva instancia\
    ● Helm charts y ArgoCD apuntando al nuevo registro\
    ● TestContainers configurados para la nueva fuente\
    #text(fill: rgb("#8a919c"))[○ Cuentas robot — pendiente]\
    #text(fill: rgb("#8a919c"))[○ Cutover completo de pipelines — pendiente]\
    #text(fill: rgb("#8a919c"))[○ Verificación de zero-pull — pendiente]
  ]
]

#v(4mm)

El mismo patrón de cada migración este año: sincronizar primero, migrar progresivamente, verificar, y luego cortar la antigua. La instancia antigua se mantiene activa hasta que las métricas de pull lleguen a cero durante una semana.

= El Portal de Desarrollo Empezó a Tomar Forma

Se está construyendo un portal interno de desarrollo sobre Backstage. El objetivo: un único lugar donde los ingenieros vean todo sobre sus servicios — versiones desplegadas por entorno, estado de pipelines, estado de sincronización, alertas — sin saltar entre cinco herramientas diferentes.

#v(3mm)

#block(
  width: 100%,
  stroke: 1pt + lightgray,
  radius: 6pt,
  inset: 4pt,
  clip: true,
)[
  #image("images/eidp.png", width: 100%)
]
#v(1mm)
#align(center)[#text(size: 6pt, style: "italic", fill: gray)[Diseño inicial del Portal Interno de Desarrollo para Ingeniería]]

#v(3mm)

Lo que se está construyendo hoy apunta a: autodescubrimiento de servicios desde repositorios, páginas de resumen autogeneradas y seguimiento de versiones en tiempo real entre entornos. Cuando se lance, incorporar un servicio será tan simple como añadir un fichero a tu repositorio.

Aún no está listo. Cada vez más cerca.

= Los Tickets de Cambio Se Escribirán Solos

Hoy, cada despliegue a producción requiere que alguien cree manualmente un ticket de cambio, recoja aprobaciones y lo cierre tras el despliegue. Funciona, pero es trabajo repetitivo.

Los cimientos para eliminar ese trabajo se construyeron este mes: una API dedicada que puede crear tickets de cambio, validar aprobaciones, bloquear despliegues no autorizados y cerrar tickets tras el éxito — todo programáticamente.

#v(3mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  let box-h = 7
  let box-w = 14
  let gap = 2

  rect((0, 0), (box-w, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Merge]])

  line((box-w, box-h / 2), (box-w + gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((box-w + gap, 0), (2 * box-w + gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((box-w + gap + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[CHG]])

  line((2 * box-w + gap, box-h / 2), (2 * box-w + 2 * gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((2 * (box-w + gap), 0), (3 * box-w + 2 * gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((2 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Aprobar]])

  line((3 * box-w + 2 * gap, box-h / 2), (3 * box-w + 3 * gap, box-h / 2), mark: (end: ">", fill: lightgray), stroke: 0.6pt + lightgray)

  rect((3 * (box-w + gap), 0), (4 * box-w + 3 * gap, box-h), fill: rgb("#f0f0f4"), stroke: 0.5pt + lightgray, radius: 2pt)
  content((3 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: gray)[Deploy]])

  line((4 * box-w + 3 * gap, box-h / 2), (4 * box-w + 4 * gap, box-h / 2), mark: (end: ">", fill: red), stroke: 0.6pt + red)

  rect((4 * (box-w + gap), 0), (5 * box-w + 4 * gap, box-h), fill: red, stroke: none, radius: 2pt)
  content((4 * (box-w + gap) + box-w / 2, box-h / 2), [#text(size: 4.5pt, weight: "bold", fill: white)[Cerrar]])
})

#v(2mm)
#align(center)[
  #text(size: 6pt, style: "italic", fill: gray)[El flujo objetivo. La API está construida. La conexión con pipelines es el siguiente paso.]
]

#v(4mm)

La API está probada, autenticada y desplegada. Aún no está conectada a los pipelines — ese es el siguiente paso. Cuando se conecte, ningún desarrollador volverá a crear un ticket de cambio a mano.

= Dos Vulnerabilidades, Dos Días

OpenBao reveló una vulnerabilidad de severidad ALTA — revocación de leases entre namespaces que saltaba los controles de acceso. Sin el parche, cualquier usuario autenticado podría revocar secretos pertenecientes a otros equipos.

Parcheado y desplegado en días.

Por separado, el controlador de ingress Nginx del clúster Harbor en DigitalOcean tenía un CVE sin parchear y ya no recibía mantenimiento upstream. Se reemplazó por Traefik — cero downtime, DNS redirigido, controlador antiguo eliminado.

Ambas respuestas siguieron el mismo patrón: detectar, evaluar, actuar, verificar. Días, no semanas.

= Un Nuevo Stack de Producto Llegó

Clearing — un proveedor global regulado de infraestructura de pagos — se está fusionando con el ecosistema Fortris. Su stack de ingeniería necesita un hogar: control de código fuente, pipelines CI/CD, cuentas cloud, runners e infraestructura de despliegue.

La plataforma empezó el trabajo de onboarding este mes. Primeros pasos: repositorios de código fuente replicados en GitLab, bootstrapping de cuentas AWS, configuración inicial de pipelines. La mayor parte del trabajo está por delante — pero el proceso está en marcha y el camino está definido.

Para esto existe una plataforma — hacer que el siguiente equipo sea tan productivo como el primero, sin reinventar la infraestructura.

= También Este Mes

Los entornos de preview se volvieron autoservicio — cualquier equipo se incorpora con un solo script. La migración de HashiCorp Vault a Kubernetes alcanzó LDT — producción es el siguiente paso, pendiente de una ventana de coordinación con infraestructura. Una cuenta de usuario de pago que los pipelines CI usaban para automatizar operaciones Git se reemplazó por una cuenta de servicio gratuita y dedicada — 400 EUR/año ahorrados, permisos reducidos de amplios a mínimos. Se configuraron certificados Apple de producción para firma de código macOS — los clientes ahora reciben binarios correctamente firmados. Se actualizó la firma de imágenes de contenedor (cosign) para corregir el método de firma. Se eliminó la infraestructura de testing de contratos PACT (sin uso). El Helm chart de Temporal migró al upstream oficial. Los proxies de charts Bitnami previenen fallos por límites de tasa. Los límites de labels en monitores protegen el pipeline de métricas. Los artefactos de escritorio ahora se publican en GitLab Releases con checksums SHA. Se provisionó un explorador de bloques BTC para los entornos de desarrollo del equipo blockchain.

Menos sorpresas. Recuperación más rápida. Más confianza por defecto.
