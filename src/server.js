const express = require('express');
const path = require('path')
const fareUtils = require('./fareutils')

// prometheus client
const client = require('prom-client')

// Create a Registry which registers the metrics
const register = new client.Registry()

// Add a default label which is added to all metrics
register.setDefaultLabels({
    app: 'nodejs-sample-app'
})

// Enable the collection of default metrics
client.collectDefaultMetrics({ register })

const counter = new client.Counter({
    name: 'node_request_operations_total',
    help: 'The total number of processed requests'
})

const histogram = new client.Histogram({
    name: 'node_request_duration_seconds',
    help: 'Histogram for the duration in seconds.',
    buckets: [1, 2, 5, 6, 10]
})

const app = express();
  
app.use(express.json())
app.use(express.urlencoded({extended: true}))
  
app.post('/calcfare', (req, res) => {
    let km = parseFloat(req.body.km)
    let min = parseInt(req.body.min)
  
    let fare = fareUtils.calcFare(km, min)
  
    res.send({fare: fare})
})

function getLocalIp() {
    const os = require('os');

    for(let addresses of Object.values(os.networkInterfaces())) {
        for(let add of addresses) {
            if(add.address.startsWith('172.')) {
                return add.address;
            } else if (add.address.startsWith('192.')) {
                return add.address;
            } else if (add.address.startsWith('10.')) {
                return add.address;
            }
        }
    }
}

app.get('/', (req, res) => {
    // simulate a sleep
    let start = new Date()
    let simulateTime = 1000

    setTimeout(function(argument){
        // execution time simulated with setTimeout function
        let end = new Date() - start
        histogram.observe(end / 1000) // convert to seconds
    }, simulateTime)

    counter.inc()

    res.send(getLocalIp())
})

// metric endpoint
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', register.contentType)
    let metrics = await register.metrics()
    res.send(metrics)
})

app.get('/rate', (req, res) => {
    res.send(fareUtils.rate)
})

app.listen(3003, () => console.log(
    'Server started on http://localhost:3003'))
