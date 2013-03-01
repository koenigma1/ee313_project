---
name: decoder
ports:
- {name: clk}
- {name: address0}
- {name: address255}
- {name: inv1}
- {name: pdec}
- {name: wl0}
- {name: wl255}
implements:
    -
        name: test
        via: port_map
        implementation:
            ports:
                clk  : clk
                address0 : address0
                address255 : address255
                inv1 : inv1
                pdec : pdec
                wl0 : wl0
                wl255: wl255
---
