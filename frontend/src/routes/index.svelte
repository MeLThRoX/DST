<script>
    import { shop_name, categories } from '../config.json'
    import Page from '../components/Page.svelte'
    import Category from '../components/category.svelte';

    import { contracts } from 'svelte-ethers-store'

    let topProducts = (products) => [...products].sort((a,b) => b.soldUnits - a.soldUnits )
    let categoryProducts = (products, category) => products.filter(p => p.category == category)

    console.log( $contracts.shop )

	const capitalizeFirstLetter = w => w.charAt(0).toUpperCase() + w.slice(1)
</script>

<svelte:head>
    <title>{shop_name}</title>
</svelte:head>

<Page>
    {#if $contracts.shop}
        {#await $contracts.shop.getProducts() }
            <p>Loading Produkts...</p>
        {:then products} 
            <div class="flex flex-col gap-y-5">
                <Category name="Top Products" products={topProducts(products)}></Category>
                {#each categories as category}
                    {#if categoryProducts(products, category).length > 0}
                        <Category name="{category}" products={categoryProducts(products, category)}></Category>
                    {/if}
                {/each}
            </div>
        {/await}
    {/if}
</Page>