import { writable } from "svelte/store";

function createCart() {
    const { subscribe, set, update} = writable<{[id: number]: number}>({})

    return {
        subscribe,
        add: (id) => update(cart => {
            if (cart[id] !== undefined) {
                cart[id] = cart[id] + 1
            } else {
                cart[id] = 1
            }
            return cart
        }),
        remove: (id) => update(cart => {
            if (cart[id] !== undefined) {
                cart[id] = cart[id] - 1
            }
            if (cart[id] === 0) {
                delete cart[id]
            }
            return cart
        }),
        set: (c) => set(c),
        reset: () => set({})
    }
}

export const cart = createCart()

if (typeof window !== "undefined") {
    if (localStorage.cart)
        cart.set(JSON.parse(localStorage.cart))
    cart.subscribe(c => localStorage.cart = JSON.stringify(c))
}