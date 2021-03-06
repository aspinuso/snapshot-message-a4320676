#!/bin/bash

function download() {
    url=$1
    dest=$2

    response=$(curl -X GET ${url} -o -)
    format=$(echo ${response} | jq -r .format)
    if [ "${format}" = "base64" ] ; then
        echo ${response} | jq -j .content | base64 -d > $dest
    elif [ "${format}" = "text" ] ; then
        echo ${response} | jq -j .content > $dest
    else
        echo "Format ${format} of file ${dest} not supported"
        echo ${response} | jq -j .content > $dest
    fi
}

notebook_created="no"

function get_notebook() {
    ## Creates a new notebook if needed. Sets flag to delete if
    ## notebook was re-created.
    apiurl=$1
    sessionid=$2
    serviceid=$3
    svcinfo=`curl --silent -X GET "${apiurl}/${serviceid}" -H  "accept: application/json"`
    if [ $(echo ${svcinfo} | jq -j .sessionId) = "${sessionid}" ] ; then
        return ## NOTEBOOK_URL unchanged.
    fi
    
    svcinfo=`curl --silent -X POST "${apiurl}" -H  "accept: application/json" \
                  -H  "Content-Type: application/json" -d "{\"sessionId\":\"${sessionid}\"}"`
    notebook_created="yes"
    
    svcurl=`echo ${svcinfo} | jq -j .serviceURL`
    if [ "${svcurl}" = "null" ] ; then
        echo "Session ${sessionid} no longer exists. Cannot download data."
        exit 1
    fi

    SERVICE_ID=`echo ${svcinfo} | jq -j .id`
    echo "Wait for service ${SERVICE_ID} to be re-created at ${svcurl}."
    while ! curl --silent -IL -X GET ${svcurl} | grep "200 OK" ; do
        sleep 5
    done
    NOTEBOOK_URL=${svcurl}
}

function delete_notebook() {
    apiurl=$1
    if [ "${notebook_created}" = "yes" ] ; then
        curl -X DELETE "${apiurl}/${SERVICE_ID}" -H  "accept: */*"
    fi
}

function download_working_dir_data() {
    if [ ! -e download_filelist.dat ] ; then
        echo "Nothing to download from working dir."
        return
    fi
    apiurl=$1
    for file in `cat download_filelist.dat` ; do
        download ${apiurl}/${file} ${HOME}/${file}
    done
}

conda install -y -c conda-forge curl jq || exit 1


# =======================================================
# Everything below here is generated by the snapshot job:
# =======================================================
NOTEBOOK_URL=https://swirrl.climate4impact.eu/swirrl/jupyter/d03711ae-b52f-43c8-bcf9-88f590e9787c
SERVICE_ID=d03711ae-b52f-43c8-bcf9-88f590e9787c
get_notebook https://swirrl.climate4impact.eu/swirrl-api/v1.0/notebook eb99ea24-40da-4737-b29f-72d1d469dab8 d03711ae-b52f-43c8-bcf9-88f590e9787c
mkdir -p ~/data/staginghistory/stage.00004
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/swirrl_fileinfo.json ~/data/staginghistory/stage.00004/swirrl_fileinfo.json
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc ~/data/staginghistory/stage.00004/cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/hurs_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc ~/data/staginghistory/stage.00004/hurs_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/ta_day_EC-Earth3_ssp585_r1i1p1f1_gr_20980101-20981231.nc ~/data/staginghistory/stage.00004/ta_day_EC-Earth3_ssp585_r1i1p1f1_gr_20980101-20981231.nc
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc ~/data/staginghistory/stage.00004/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00004/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc ~/data/staginghistory/stage.00004/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc
mkdir -p ~/data/staginghistory/stage.00003
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00003/swirrl_fileinfo.json ~/data/staginghistory/stage.00003/swirrl_fileinfo.json
ln ~/data/staginghistory/stage.00004//cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc ~/data/staginghistory/stage.00003/cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc
ln ~/data/staginghistory/stage.00004//hurs_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc ~/data/staginghistory/stage.00003/hurs_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc
ln ~/data/staginghistory/stage.00004//huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc ~/data/staginghistory/stage.00003/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc
ln ~/data/staginghistory/stage.00004//huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc ~/data/staginghistory/stage.00003/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc
mkdir -p ~/data/staginghistory/stage.00002
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00002/swirrl_fileinfo.json ~/data/staginghistory/stage.00002/swirrl_fileinfo.json
ln ~/data/staginghistory/stage.00003//cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc ~/data/staginghistory/stage.00002/cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc
ln ~/data/staginghistory/stage.00003//huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc ~/data/staginghistory/stage.00002/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_198901-199012.nc
ln ~/data/staginghistory/stage.00003//huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc ~/data/staginghistory/stage.00002/huss_AFR-44_ECMWF-ERAINT_evaluation_r1i1p1_DMI-HIRHAM5_v2_mon_199101-200012.nc
mkdir -p ~/data/staginghistory/stage.00001
download ${NOTEBOOK_URL}/api/contents/data/staginghistory/stage.00001/swirrl_fileinfo.json ~/data/staginghistory/stage.00001/swirrl_fileinfo.json
ln ~/data/staginghistory/stage.00002//cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc ~/data/staginghistory/stage.00001/cct_Amon_MPI-ESM-LR_decadal1997_r1i1p1_199801-200712.nc
ln -s ~/data/staginghistory/stage.00004 ~/data/latest
download_working_dir_data ${NOTEBOOK_URL}/api/contents
delete_notebook https://swirrl.climate4impact.eu/swirrl-api/v1.0/notebook
