class Event {
  constructor() {
    this.events = {}
  }

  register(name, callback) {
    if (!this.events[name])
      this.events[name] = []
    this.events[name].push(callback)
  }

  trigger(name, event) {
    const { events } = this
    if (events[name])
      for (let callback of events[name])
        setTimeout(() => callback(event), 0)
  }
}


module.exports = Event