<script>
    // @ts-nocheck
    import { shop_name } from '../config.json'
    import Button from '../components/sButton.svelte'
    import Page from '../components/Page.svelte'
    import { contracts } from "svelte-ethers-store"
    import { cart } from "../cart"
	import { contract_address } from '../config.json'

    const productsFromCart = (cart) => Object.keys(cart).map(id => products.find(p => p.ID === id))
    const capitalizeFirstLetter = (w) => w.charAt(0).toUpperCase() + w.slice(1);
    
    let buyLoading = false

    let buy = async () => {
        buyLoading = true
        let products = await $contracts.shop.getProducts()
        let price = Object.keys($cart).map(id => products.find(p => p.ID == id)).map(p => Number(p.pricePerUnit)).reduce((p1,p2) => p1+p2, 0)
        
        await (await $contracts.erc20.approve(contract_address, price)).wait()
        let input = Object.keys($cart).map(id => [Number(id), $cart[id]])
        await $contracts.shop.buyCart(input, "Test")
        buyLoading = false
        cart.reset()
    }
</script>
    
<svelte:head>
    <title>{shop_name} - Cart</title>
</svelte:head>

<Page>
    {#await $contracts.shop.getProducts()}
        <p>Loading Products...</p>
    {:then products} 
        <div class="flex flex-col gap-5">
            <div class="flex justify-between">
                <h1 class="text-3xl">Cart</h1>
                <div class="flex gap-5">
                    <Button onclick={() => buyLoading ? (() => {}) : buy()} type="success">
                        {#if buyLoading}
                            <i class="fa-solid fa-spinner-third fa-spin"></i>
                        {:else} 
                            <i class="fa-solid fa-money-bill-wave"></i>
                        {/if}
                    </Button>
                    <Button onclick={() => cart.reset()} type="urgent">
                        <i class="fa-solid fa-cart-circle-xmark"></i>
                    </Button>

                </div>
            </div>
            {#if Object.keys($cart).map(id => products.find(p => p.ID == id)).length === 0}
                <h1 class="text-xl">There is nothing in your Cart. Add some products and come back!</h1>
            {/if}
            <div class="flex flex-col gap-3">
                {#each Object.keys($cart).map(id => products.find(p => p.ID == id)) as product}
                    <div class="bg-slate-800 w-full h-80 rounded-md flex gap-5 p-3">
                        <!-- svelte-ignore a11y-img-redundant-alt -->
                        <img
                            src="https://ipfs.io/ipfs/{product.pictureHash}"
                            alt="Image from IPFS"
                            class="h-full object-center object-cove rounded-md"
                        />
                        <div class="flex flex-col gap-3 justify-between">
                            <div>
                                <h3 class="text-2xl font-bold text-white">{product.name}</h3>
                                <p class="mt-1 text-gray-500">{product.description}</p>
                            </div>
                            <div class="flex justify-between">
                                <div class="flex gap-2 text-2xl font-medium">
                                    <p>{$cart[product.ID]}</p>
                                    <p>x</p>
                                    <p class="text-green-300">${product.pricePerUnit}</p>
                                </div>
                                <div class="flex gap-3">
                                    <Button onclick={() => cart.remove(product.ID)}>
                                        <i class="fa-solid fa-minus"></i>
                                    </Button>
                                    <Button onclick={() => cart.add(product.ID)}>
                                        <i class="fa-solid fa-plus"></i>
                                    </Button>
                                </div>
                            </div>
                        </div>
                    </div>
                {/each}
            </div>
        </div>
    {/await}
</Page>