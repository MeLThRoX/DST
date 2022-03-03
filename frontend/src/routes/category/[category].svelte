<script>
    import { shop_name } from '../../config.json'
    import Page from '../../components/Page.svelte'
    import { page } from '$app/stores';
</script>

<svelte:head>
    <title>{shop_name} - {$page.params.category}</title>
</svelte:head>

<Page>
    <h1>{$page.params.category}</h1>
</Page>