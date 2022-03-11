<script>
    import { shop_name, categories } from '../config.json'
    import Page from '../components/Page.svelte'
</script>

<svelte:head>
    <title>{shop_name}</title>
</svelte:head>

<Page>
    {#each categories as categorie}
        <div class="bg-slate-800 h-64 w-auto rounded-md my-5 p-3">
            <h1>{categorie}</h1>
        </div>
    {/each}
</Page>