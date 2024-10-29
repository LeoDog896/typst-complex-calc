#import "lib.typ" as cc

#assert.eq(cc.abs(-1), 1)
#assert.eq(cc.add(-2, 4), cc.complex(2, 0))
#assert.eq(cc.neg(cc.complex(2, 2)), cc.complex(-2, -2))
#assert.eq(cc.add(cc.complex(5, -7), cc.complex(-2, 3)), cc.complex(3, -4))
#assert(cc.pow(cc.complex(0, 1), cc.complex(0, 1)).real < 0.20788)