#import "graceful-genetics/src/lib.typ" as graceful-genetics
#import "@preview/cetz:0.4.2" as cetz

// Fortris brand colors
#let gray = rgb("#2f3849")
#let red = rgb("#F07C70")
#let white = rgb("#F8F7F8")
#let lightgray = rgb("#C9CED8")

#show: graceful-genetics.template.with(
  title: [Swarm Perdió Su Última Excusa],
  authors: (
    (
      name: "Mayo 2026",
      department: "Platform Engineering",
      institution: "",
      city: "Remoto",
      country: "Global",
      mail: "platform@fortris.com",
    ),
  ),
  date: (
    year: 2026,
    month: "May",
    day: 1,
  ),
  keywords: (
    "Platform Engineering",
    "Docker Swarm",
    "Kubernetes",
    "MongoDB",
    "Kafka",
    "Strimzi",
    "Vault",
    "SonarQube",
  ),
  doi: "10.0000/fortris.platform.2026.05",
  abstract: [
    Docker Swarm ya no es un destino de despliegue. Las últimas bases de datos
    migraron, el Vault de cliente se trasladó a Kubernetes, la gestión de topics
    Kafka se hizo nativa, y los pipelines CI/CD eliminaron el soporte a Swarm
    por completo. Cinco meses de ejecución disciplinada — de "listo para migrar"
    en enero a "no se puede desplegar ahí" en mayo. La retirada de infraestructura
    legacy ya no es un plan. Está hecho.
  ],
)

#set text(font: ("Manrope", "Arial", "Helvetica"), fill: gray)

= 24 de 24

La última fase de migración de MongoDB se completó. Todas las bases de datos restantes — las catalogadas como "Muy Alto" riesgo — ya corren en Kubernetes.

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[FASE 4 — EL LOTE MÁS DIFÍCIL]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr, 1fr),
      gutter: 3mm,
      [
        treasury\_services ·  #text(fill: red)[Muy Alto]\
        cams\_psp ·  #text(fill: red)[Muy Alto]\
        order\_services ·  #text(fill: red)[Muy Alto]\
        orion ·  #text(fill: red)[Muy Alto]
      ],
      [
        blockchain\_transaction · Alto\
        bows · Alto\
        btc\_send\_order\_batch · Alto\
        fortris\_balances · Medio
      ],
    )
  ]
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    Todas migradas con ventanas de downtime planificadas. Esto es el núcleo financiero — pagos, saldos, órdenes, transacciones blockchain.
  ]
]

#v(4mm)

#cetz.canvas(length: 1mm, {
  import cetz.draw: *

  // Full progress bar
  rect((0, 0), (78, 6), fill: red, stroke: none, radius: 3pt)
  content((39, 3), [#text(size: 6pt, weight: "bold", fill: white)[24 / 24 bases de datos en Kubernetes]])
})

#v(2mm)
#align(center)[
  #text(size: 7pt, weight: "bold", fill: red)[100% completado.]
  #text(size: 6.5pt, fill: gray)[ Docker Swarm ya no aloja ningún dato de MongoDB.]
]

#v(4mm)

Lo que empezó en enero como "sincronización activa, listo para migrar" llegó a su conclusión en mayo. Cuatro fases. Cero pérdida de datos. El núcleo financiero del sistema ahora corre íntegramente en Kubernetes.

= El Vault del Cliente También Migró

El Vault C3/C3X — la infraestructura de custodia segura donde los clientes firman transacciones — migró de Docker Swarm a Kubernetes.

Esto no era una preocupación interna de plataforma. Es infraestructura de cliente. Los requisitos eran absolutos: cero pérdida de datos, downtime mínimo, y una experiencia de cliente positiva en todo momento.

El equipo de plataforma construyó el Helm chart que lo hizo posible — dando a los clientes las herramientas para autogestionar su Vault en Kubernetes basándose en la documentación de Fortris.

La migración fue un éxito. El cliente ahora opera en Kubernetes. Una de las dependencias más antiguas de Docker Swarm — y la más sensible — ha desaparecido.

= Los Topics de Kafka Se Convirtieron en Código

La gestión de topics Kafka pasó de un operador personalizado en Swarm a recursos nativos de Kubernetes gestionados por el Strimzi Topic Operator.

El antiguo `swarm-kafka-topics-operator` ha sido archivado.

Ahora, gestionar topics de Kafka funciona como cualquier otro cambio de infraestructura:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[CÓMO SE GESTIONAN LOS TOPICS AHORA]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [1. Editar un fichero YAML — definir nombre del topic, particiones, retención, replicación],
      [2. Abrir un merge request — el pipeline muestra un diff de cambios entre entornos],
      [3. Obtener aprobación de Platform + code owners],
      [4. Merge — el pipeline aplica el cambio automáticamente vía ArgoCD],
    )
  ]
  #v(2mm)
  #text(size: 6pt, style: "italic", fill: gray)[
    Los topics changelog críticos están separados de los estándar. Cambios de particiones requieren opt-in explícito.
  ]
]

#v(4mm)

También se desplegó una interfaz visual de Kafka en el entorno de desarrollo — dando a los desarrolladores acceso visual al estado de los topics, grupos de consumidores y salud del clúster sin herramientas de línea de comandos.

Este enfoque es compatible con el futuro: funciona con el clúster Kafka actual en Swarm y funcionará idénticamente cuando se complete el traslado a Kafka gestionado (MSK).

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #text(size: 7pt, weight: "bold", fill: gray)[QUÉ SE ENTREGÓ PARA LA PREPARACIÓN MSK]
  #v(3mm)
  #text(size: 7pt, fill: gray)[
    #grid(
      columns: (1fr),
      gutter: 2mm,
      [*Gestión de topics (Strimzi) funciona en ambos clústeres Swarm y MSK* — topics propagados a DEV, LDT y PROD],
      [*AKHQ desplegado* — interfaz de monitorización unificada mostrando ambos clústeres lado a lado],
      [*Certificados mTLS entregados* — formatos JKS/PKCS12 con cadena CA completa de Amazon. Los servicios Java pueden autenticarse en MSK],
      [*CRDs de Strimzi gestionados independientemente* — ArgoCD con orden de sincronización adecuado],
    )
  ]
]

#v(4mm)

Las herramientas están listas para ambos clústeres. Los servicios no necesitarán cambiar.

= El Pipeline Olvidó Cómo Desplegar en Swarm

Los pipelines CI/CD ya no soportan Docker Swarm como destino de despliegue.

Esto no es un aviso de deprecación. Es una eliminación. El mecanismo de despliegue se ha actualizado — los servicios físicamente no pueden desplegarse en Swarm aunque alguien lo intentara.

Combinado con la migración completa de MongoDB y el Vault trasladado a Kubernetes, Docker Swarm ha perdido toda razón de existir:

#v(3mm)

#block(width: 100%, stroke: 0.5pt + lightgray, radius: 6pt, inset: 10pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    [
      #text(size: 7pt, weight: "bold", fill: rgb("#8a919c"))[SWARM ALOJABA (Ene 2026)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        24 bases de datos MongoDB\
        Vault C3/C3X\
        Operador de topics Kafka\
        Soporte de despliegue CI/CD\
        Servicios activos
      ]
    ],
    [
      #text(size: 7pt, weight: "bold", fill: red)[SWARM ALOJA (May 2026)]
      #v(2mm)
      #text(size: 7pt, fill: gray)[
        Nada nuevo se despliega aquí\
        Clúster Kafka (gestionado externamente)\
        Pendiente de decomisión final
      ]
    ],
  )
]

#v(4mm)

Cinco meses. De "el runtime legacy" a "no soportado."

= SonarQube Encontró Su Hogar

SonarQube — la herramienta de análisis estático de código usada por todos los equipos de ingeniería — migró al clúster de producción de la plataforma en `codereview.hub.codecraft.tools`.

Otra herramienta que antes vivía en infraestructura IT corporativa, ahora operada por el equipo de plataforma. El mismo patrón de cada migración: dominio predecible, ciclo de vida gestionado por plataforma, aislado de sistemas no relacionados.

= Limpiando los Restos

Con Swarm sin recibir ya despliegues, comenzó la limpieza:

- Herramientas legacy de gestión de Swarm eliminadas de la infraestructura (Portainer, DeployD API, apps-config-crypt)
- Repositorios de operadores de plataforma relacionados con Swarm archivados
- Imágenes legacy de contenedores de despliegue (`tn-deploy`) deprecadas y eliminadas — usaban suplantación insegura de usuarios que ya no tiene razón de existir
- Repositorios de apps-config archivados

Lo que no puede desplegarse tampoco debería existir en el código. El código muerto atrae confusión.

= Qué Significa Mayo

Mayo es el mes en que el plan de retirada de infraestructura legacy dejó de ser un plan.

Docker Swarm ya no aloja bases de datos. Ya no ejecuta infraestructura de cliente. Ya no recibe despliegues. El sistema CI/CD se ha olvidado de que existe.

Lo que queda en Swarm es Kafka (migrando a MSK) y HashiCorp Vault (migrando a Kubernetes). Ambos tienen plan. Ninguno está bloqueado. La plataforma dejó de desplegar aplicaciones en Swarm — lo que queda es infraestructura retirándose a su propio ritmo.

El equipo de plataforma entregó lo que prometió en enero: Kubernetes como el único runtime que importa. Llevó cinco meses de ejecución disciplinada y por fases. Sin atajos. Sin incidentes durante la migración. Sin datos perdidos.

Hecho.
