
export const formataddy = (addy: string) => {
  const firstfivea = addy.substring(0, 6)
  const address = (firstfivea + '.' + addy?.substring(6,)?.match(/.{1,4}/g)?.join('.')).toLowerCase();
  return address
}

export const removeDots = (s: string) => {
  return s.replace(/\./g, '')
}

// split string with slash between 0x0/0x0
export const splitString = (s: string) => {
  const res = s.split('/')
  return [res[0], res[1]]
}

export const TEN_18 = BigInt('1000000000000000000')