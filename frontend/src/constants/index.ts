import Decimal from "decimal.js";

export const formataddy = (addy: string) => {
  const firstfivea = addy.substring(0, 6)
  const address = (firstfivea + '.' + addy?.substring(6,)?.match(/.{1,4}/g)?.join('.')).toLowerCase();
  return address
}

export const removeDots = (s: string) => {
  return s.replace(/\./g, '')
}

export const udToDecimal = (s: string): Decimal => {
  if (s === '') return new Decimal(0)

  return new Decimal(removeDots(s)).div(TEN_18)
}

export const displayPubKey = (pubKey: string) => pubKey.slice(0, 6) + '...' + pubKey.slice(-4)

// split string with slash between 0x0/0x0
export const splitString = (s: string) => {
  const res = s.split('/')
  return [res[0], res[1]]
}

export const TEN_18 = new Decimal('1000000000000000000')

export const addDecimalDots = (decimal: string | number) => {
  const num = typeof decimal === 'number' ? decimal.toString() : decimal
  const number: string[] = []
  const len = num.length;
  for (let i = 0; i < len; i++) {
    if (i !== 0 && i % 3 === 0) {
      number.push('.')
    }
    number.push(num[len - 1 - i])
  }
  return number.reverse().join('')
}