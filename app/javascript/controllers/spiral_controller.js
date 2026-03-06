import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const steps = JSON.parse(this.element.dataset.steps || "[]")
    this.renderSpiral(steps)
  }

  renderSpiral(steps) {
    this.element.querySelectorAll(".fib-point").forEach(el => el.remove())

    const canvas = this.element.querySelector("#spiral-canvas")
    if (!canvas) return

    const W = this.element.offsetWidth
    const H = this.element.offsetHeight
    canvas.width = W
    canvas.height = H

    const ctx = canvas.getContext("2d")
    const cx = W / 2, cy = H / 2
    const maxR = Math.min(W, H) * 0.47
    const turns = 5
    const stepsCount = 2000

    const grd = ctx.createRadialGradient(cx, cy, 0, cx, cy, W * 0.5)
    grd.addColorStop(0, "rgba(140,130,114,0.08)")
    grd.addColorStop(1, "rgba(0,0,0,0)")
    ctx.fillStyle = grd
    ctx.fillRect(0, 0, W, H)

    const drawSpiral = (scale, opacity, lineWidth) => {
      ctx.beginPath()
      for (let i = 0; i <= stepsCount; i++) {
        const t = (i / stepsCount) * turns * 2 * Math.PI
        const r = maxR * scale * Math.exp(-0.17 * (turns * 2 * Math.PI - t))
        const x = cx + r * Math.cos(t)
        const y = cy + r * Math.sin(t)
        i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y)
      }
      ctx.strokeStyle = `rgba(140,130,114,${opacity})`
      ctx.lineWidth = lineWidth
      ctx.stroke()
    }

    drawSpiral(1, 0.35, 1.2)
    drawSpiral(0.85, 0.12, 0.6)

    if (steps.length === 0) return

    const pathSamples = []
    for (let i = 0; i <= stepsCount; i++) {
      const t = (i / stepsCount) * turns * 2 * Math.PI
      const r = maxR * Math.exp(-0.17 * (turns * 2 * Math.PI - t))
      pathSamples.push({ x: cx + r * Math.cos(t), y: cy + r * Math.sin(t) })
    }

    const cumLen = [0]
    for (let i = 1; i < pathSamples.length; i++) {
      const dx = pathSamples[i].x - pathSamples[i - 1].x
      const dy = pathSamples[i].y - pathSamples[i - 1].y
      cumLen.push(cumLen[i - 1] + Math.sqrt(dx * dx + dy * dy))
    }
    const totalLen = cumLen[cumLen.length - 1]
    const totalPoints = steps.length

    steps.forEach((step, i) => {
      const target = totalPoints > 1
        ? (i / (totalPoints - 1)) * totalLen
        : totalLen / 2

      let lo = 0, hi = cumLen.length - 1
      while (lo < hi - 1) {
        const mid = Math.floor((lo + hi) / 2)
        cumLen[mid] < target ? lo = mid : hi = mid
      }
      const { x, y } = pathSamples[hi]

      const dot = document.createElement("div")
      dot.className = "fib-point" + (i === 0 ? " highlight" : "") + (step.done ? " done" : "")
      dot.style.left = x + "px"
      dot.style.top = y + "px"
      dot.setAttribute("data-bs-toggle", "modal")
      dot.setAttribute("data-bs-target", `#stepModal-${step.id}`)
      dot.innerHTML = `
        <div class="point-ring">${step.position}</div>
        <div class="point-label">${step.title}</div>
      `
      this.element.appendChild(dot)
    })
  }
}
