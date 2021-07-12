
workflow pb_merge {
    take:
        data
    main:
        data |
            toSortedList() |
            map { it.collect { it[1] } } |
            pb_merge_task
    emit:
        bam = merge.out.bam
}

process pb_merge_task {
    label 'M'
    publishDir "intermediates/pb_merge", mode: "$params.intermediate_pub_mode"

    input:
        path bams

    output:
        path merged, emit: bam

    script:
        merged = params.run_id + '.ccs_merged.bam'
        """
        pbmerge ${bams.join(' ')} -o $merged --no-pbi
        """
}