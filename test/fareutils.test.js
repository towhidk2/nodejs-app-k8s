// Importing mocha and chai
const mocha = require('mocha')
const chai = require('chai')
  
// Importing fareutils.js where our code is written
const fareUtils = require('../src/fareutils')
  
const expect = chai.expect
  
// Group of tests using describe
describe('fareUtils', function () {
  
    // We will describe each single test using it
    it('expect fare to be 50 for 0km, 0min', () => {
        let fare = fareUtils.calcFare(0, 0)
        expect(fare).to.equal(50)
    })
  
    it('expect fare to be 100 for 10km, 0min', () => {
        let fare = fareUtils.calcFare(10, 0)
        expect(fare).to.equal(100)
    })
  
    it('expect fare to be 56 for 2km, 18min', () => {
        let fare = fareUtils.calcFare(2, 18)
        expect(fare).to.equal(56)
    })
})
