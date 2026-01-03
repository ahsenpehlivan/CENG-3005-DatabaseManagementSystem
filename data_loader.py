import pandas as pd
import mysql.connector
import numpy as np

# ---------------------------------------------------------
# 1. AYARLAR
# ---------------------------------------------------------
db_config = {
    'user': 'root',
    'password': 'Ahsen1mysql',  # <-- ŞİFRENİZİ BURAYA GİRİN
    'host': '127.0.0.1',
    'raise_on_warnings': False
}

DB_NAME = 'pipline_db' 
csv_file = 'database_renew.csv'

# ---------------------------------------------------------
# 2. TEMİZLİK VE KURULUM SORGULARI
# ---------------------------------------------------------
init_statements = [
    f"DROP SCHEMA IF EXISTS `{DB_NAME}`",
    f"CREATE SCHEMA `{DB_NAME}` DEFAULT CHARACTER SET utf8mb4",
    f"USE `{DB_NAME}`"
]

ddl_statements = [
    """CREATE TABLE `OPERATOR` (
      `OperatorID` INT NOT NULL,
      `OperatorName` VARCHAR(255) NOT NULL,
      PRIMARY KEY (`OperatorID`),
      UNIQUE INDEX `OperatorID_UNIQUE` (`OperatorID` ASC)) ENGINE = InnoDB""",
      
    """CREATE TABLE `LIQUID_CLASS` (
      `LiquidSubtypeID` INT NOT NULL AUTO_INCREMENT,
      `LiquidSubtype` VARCHAR(255) NULL,
      `LiquidType` VARCHAR(255) NOT NULL,
      PRIMARY KEY (`LiquidSubtypeID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `CAUSE_CATEGORY` (
      `CauseCategoryID` INT NOT NULL AUTO_INCREMENT,
      `CauseCategoryName` VARCHAR(200) NOT NULL,
      PRIMARY KEY (`CauseCategoryID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `CAUSE_SUBCATEGORY` (
      `CauseSubcategoryID` INT NOT NULL AUTO_INCREMENT,
      `CauseSubcategoryName` VARCHAR(200) NOT NULL,
      `CC_CauseCategoryID` INT NOT NULL,
      PRIMARY KEY (`CauseSubcategoryID`),
      FOREIGN KEY (`CC_CauseCategoryID`) REFERENCES `CAUSE_CATEGORY` (`CauseCategoryID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `PIPELINE_FACILITY` (
      `PiplineFacilityID` INT NOT NULL AUTO_INCREMENT,
      `PipelineFacilityName` VARCHAR(255) NULL,
      `PipelineLocation` VARCHAR(255) NOT NULL,
      `PipelineType` VARCHAR(255) NULL,
      `OP_OperatorID` INT NOT NULL,
      PRIMARY KEY (`PiplineFacilityID`, `OP_OperatorID`),
      FOREIGN KEY (`OP_OperatorID`) REFERENCES `OPERATOR` (`OperatorID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `LIQUID_NAME` (
      `LiquidID` INT NOT NULL AUTO_INCREMENT,
      `LiquidName` VARCHAR(255) NULL,
      `LC_LiquidSubtypeID` INT NOT NULL,
      PRIMARY KEY (`LiquidID`),
      FOREIGN KEY (`LC_LiquidSubtypeID`) REFERENCES `LIQUID_CLASS` (`LiquidSubtypeID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `STATE` (
      `StateID` INT NOT NULL AUTO_INCREMENT,
      `AccidentState` VARCHAR(45) NULL,
      PRIMARY KEY (`StateID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `COUNTY_TO_STATE` (
      `CountyID` INT NOT NULL AUTO_INCREMENT,
      `AccidentCounty` VARCHAR(45) NULL,
      `ST_StateID` INT NOT NULL,
      PRIMARY KEY (`CountyID`),
      FOREIGN KEY (`ST_StateID`) REFERENCES `STATE` (`StateID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `CITY_TO_COUNTY` (
      `CityID` INT NOT NULL AUTO_INCREMENT,
      `AccidentCity` VARCHAR(45) NULL,
      `COTS_CountyID` INT NOT NULL,
      PRIMARY KEY (`CityID`),
      FOREIGN KEY (`COTS_CountyID`) REFERENCES `COUNTY_TO_STATE` (`CountyID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_LOCATION` (
      `AccidentLatitude` FLOAT NOT NULL,
      `AccidentLongitude` FLOAT NOT NULL,
      `CTCO_CityID` INT NOT NULL,
      PRIMARY KEY (`AccidentLatitude`, `AccidentLongitude`),
      FOREIGN KEY (`CTCO_CityID`) REFERENCES `CITY_TO_COUNTY` (`CityID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_RESULTS` (
      `ResultID` INT NOT NULL AUTO_INCREMENT,
      `Liquid_Ignition` TINYINT(1) NOT NULL,
      `Liquid_Explosion` TINYINT(1) NOT NULL,
      `Pipline_Shutdown` TINYINT(1) NULL,
      `Shutdown_DateTime` DATETIME NULL,
      `Restart_DateTime` DATETIME NULL,
      PRIMARY KEY (`ResultID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_REPORT` (
      `ReportNumber` INT NOT NULL,
      `SupplementalNumber` INT NOT NULL,
      `AccidentDateTime` DATETIME NOT NULL,
      `AL_AccidentLatitude` FLOAT NOT NULL,
      `AL_AccidentLongitude` FLOAT NOT NULL,
      `LN_LiquidID` INT NOT NULL,
      `CS_CauseSubcategoryID` INT NOT NULL,
      `PF_PiplineFacilityID` INT NOT NULL,
      `PF_OP_OperatorID` INT NOT NULL,
      `AR_ResultID` INT NOT NULL,
      PRIMARY KEY (`ReportNumber`, `AR_ResultID`),
      FOREIGN KEY (`AL_AccidentLatitude` , `AL_AccidentLongitude`) REFERENCES `ACCIDENT_LOCATION` (`AccidentLatitude` , `AccidentLongitude`),
      FOREIGN KEY (`LN_LiquidID`) REFERENCES `LIQUID_NAME` (`LiquidID`),
      FOREIGN KEY (`CS_CauseSubcategoryID`) REFERENCES `CAUSE_SUBCATEGORY` (`CauseSubcategoryID`),
      FOREIGN KEY (`PF_PiplineFacilityID` , `PF_OP_OperatorID`) REFERENCES `PIPELINE_FACILITY` (`PiplineFacilityID` , `OP_OperatorID`),
      FOREIGN KEY (`AR_ResultID`) REFERENCES `ACCIDENT_RESULTS` (`ResultID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `IMPACT_TYPE` (
      `ImpactTypeID` INT NOT NULL,
      `ImpactGroup` VARCHAR(200) NOT NULL,
      `Party` VARCHAR(200) NOT NULL,
      PRIMARY KEY (`ImpactTypeID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `COST_TYPE` (
      `CostTypeID` INT NOT NULL AUTO_INCREMENT,
      `CostTypeName` VARCHAR(200) NOT NULL,
      PRIMARY KEY (`CostTypeID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_IMPACTS` (
      `IT_ImpactTypeID` INT NOT NULL,
      `AR_ResultID` INT NOT NULL,
      `ImpactValue` INT NULL,
      PRIMARY KEY (`IT_ImpactTypeID`, `AR_ResultID`),
      FOREIGN KEY (`IT_ImpactTypeID`) REFERENCES `IMPACT_TYPE` (`ImpactTypeID`),
      FOREIGN KEY (`AR_ResultID`) REFERENCES `ACCIDENT_RESULTS` (`ResultID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_COSTS` (
      `CT_CostTypeID` INT NOT NULL,
      `AR_ResultID` INT NOT NULL,
      `Amount` DECIMAL(14,2) NULL,
      PRIMARY KEY (`CT_CostTypeID`, `AR_ResultID`),
      FOREIGN KEY (`CT_CostTypeID`) REFERENCES `COST_TYPE` (`CostTypeID`),
      FOREIGN KEY (`AR_ResultID`) REFERENCES `ACCIDENT_RESULTS` (`ResultID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `SPILL_TYPE` (
      `SpillTypeID` INT NOT NULL AUTO_INCREMENT,
      `SpillTypeName` VARCHAR(100) NOT NULL,
      PRIMARY KEY (`SpillTypeID`)) ENGINE = InnoDB""",
      
    """CREATE TABLE `ACCIDENT_SPILL_VOLUME` (
      `AR_ResultID` INT NOT NULL,
      `ST_SpillTypeID` INT NOT NULL,
      `Barrel` INT NULL,
      PRIMARY KEY (`AR_ResultID`, `ST_SpillTypeID`),
      FOREIGN KEY (`AR_ResultID`) REFERENCES `ACCIDENT_RESULTS` (`ResultID`),
      FOREIGN KEY (`ST_SpillTypeID`) REFERENCES `SPILL_TYPE` (`SpillTypeID`)) ENGINE = InnoDB"""
]

# ---------------------------------------------------------
# 3. MAPPING VE YARDIMCI FONKSİYONLAR
# ---------------------------------------------------------
cost_mapping = {
    'Property Damage Costs': 'Property Damage',
    'Lost Commodity Costs': 'Lost Commodity',
    'Public/Private Property Damage Costs': 'Public/Private Property Damage',
    'Emergency Response Costs': 'Emergency Response',
    'Environmental Remediation Costs': 'Environmental Remediation',
    'Other Costs': 'Other'
}
spill_mapping = {
    'Unintentional Release (Barrels)': 'Unintentional Release',
    'Intentional Release (Barrels)': 'Intentional Release',
    'Liquid Recovery (Barrels)': 'Liquid Recovery',
    'Net Loss (Barrels)': 'Net Loss'
}
impact_mapping = {
    'Operator Employee Injuries': ('Injury', 'Operator Employee'),
    'Operator Contractor Injuries': ('Injury', 'Operator Contractor'),
    'Emergency Responder Injuries': ('Injury', 'Emergency Responder'),
    'Other Injuries': ('Injury', 'Other'),
    'Public Injuries': ('Injury', 'Public'),
    'Operator Employee Fatalities': ('Fatality', 'Operator Employee'),
    'Operator Contractor Fatalities': ('Fatality', 'Operator Contractor'),
    'Emergency Responder Fatalities': ('Fatality', 'Emergency Responder'),
    'Other Fatalities': ('Fatality', 'Other'),
    'Public Fatalities': ('Fatality', 'Public')
}

def get_or_create(cursor, select_sql, select_params, insert_sql, insert_params):
    cursor.execute(select_sql, select_params)
    result = cursor.fetchone()
    if result:
        return result[0]
    cursor.execute(insert_sql, insert_params)
    return cursor.lastrowid

# ---------------------------------------------------------
# 4. ÇALIŞTIRMA BLOĞU
# ---------------------------------------------------------
try:
    print("Veritabanına bağlanılıyor...")
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()
    
    # A) KOMPLE TEMİZLİK VE YENİDEN OLUŞTURMA
    print("Veritabanı sıfırlanıyor (Eski veriler siliniyor)...")
    for sql in init_statements:
        cursor.execute(sql)
    
    print("Yeni tablolar oluşturuluyor...")
    for sql in ddl_statements:
        cursor.execute(sql)
    conn.commit()
    print("Veritabanı şeması tertemiz bir şekilde hazırlandı.")

    # B) VERİ OKUMA VE YÜKLEME
    print("CSV dosyası okunuyor...")
    df = pd.read_csv(csv_file)
    
    # Veri Temizleme
    date_cols = ['Accident Date/Time', 'Shutdown Date/Time', 'Restart Date/Time']
    for col in date_cols:
        df[col] = pd.to_datetime(df[col], errors='coerce')
        df[col] = df[col].astype(object).where(df[col].notnull(), None)

    numeric_cols = list(cost_mapping.keys()) + list(spill_mapping.keys()) + list(impact_mapping.keys())
    for col in numeric_cols:
        df[col] = pd.to_numeric(df[col], errors='coerce').fillna(0)
    
    df = df.where(pd.notnull(df), None)

    bool_map = {'YES': 1, 'NO': 0, 'Yes': 1, 'No': 0, None: 0}
    bool_cols = ['Liquid Ignition', 'Liquid Explosion', 'Pipeline Shutdown', 'Public Evacuations']
    for col in bool_cols:
        if col in df.columns:
            df[col] = df[col].map(bool_map).fillna(0)
            
    print("Statik Tablolar (Types) hazırlanıyor...")
    
    # A) COST_TYPE
    cost_type_ids = {}
    for col_name, type_name in cost_mapping.items():
        c_id = get_or_create(cursor, 
            "SELECT CostTypeID FROM COST_TYPE WHERE CostTypeName = %s", (type_name,),
            "INSERT INTO COST_TYPE (CostTypeName) VALUES (%s)", (type_name,)
        )
        cost_type_ids[col_name] = c_id

    # B) SPILL_TYPE
    spill_type_ids = {}
    for col_name, type_name in spill_mapping.items():
        s_id = get_or_create(cursor,
            "SELECT SpillTypeID FROM SPILL_TYPE WHERE SpillTypeName = %s", (type_name,),
            "INSERT INTO SPILL_TYPE (SpillTypeName) VALUES (%s)", (type_name,)
        )
        spill_type_ids[col_name] = s_id

    # C) IMPACT_TYPE
    impact_type_ids = {}
    for col_name, (group, party) in impact_mapping.items():
        cursor.execute("SELECT ImpactTypeID FROM IMPACT_TYPE WHERE ImpactGroup = %s AND Party = %s", (group, party))
        result = cursor.fetchone()
        if result:
            i_id = result[0]
        else:
            cursor.execute("SELECT MAX(ImpactTypeID) FROM IMPACT_TYPE")
            val = cursor.fetchone()[0]
            max_id = val if val is not None else 0
            i_id = max_id + 1
            cursor.execute("INSERT INTO IMPACT_TYPE (ImpactTypeID, ImpactGroup, Party) VALUES (%s, %s, %s)", (i_id, group, party))
        impact_type_ids[col_name] = i_id
    conn.commit()

    print("Veri yükleme başlıyor...")
    
    # Cache Sözlükleri
    cache_operator = {}
    cache_liquid_class = {}
    cache_cause_cat = {}
    cache_state = {}
    cache_county = {}
    cache_city = {}
    
    for index, row in df.iterrows():
        
        # OPERATOR
        op_id = row['Operator ID']
        if op_id not in cache_operator:
            cursor.execute("INSERT IGNORE INTO OPERATOR (OperatorID, OperatorName) VALUES (%s, %s)", (op_id, row['Operator Name']))
            cache_operator[op_id] = op_id
        
        # LIQUID
        l_type = row['Liquid Type']
        l_sub = row['Liquid Subtype']
        l_name = row['Liquid Name']
        
        if (l_type, l_sub) not in cache_liquid_class:
            lc_id = get_or_create(cursor,
                "SELECT LiquidSubtypeID FROM LIQUID_CLASS WHERE LiquidType=%s AND (LiquidSubtype=%s OR (LiquidSubtype IS NULL AND %s IS NULL))", (l_type, l_sub, l_sub),
                "INSERT INTO LIQUID_CLASS (LiquidType, LiquidSubtype) VALUES (%s, %s)", (l_type, l_sub)
            )
            cache_liquid_class[(l_type, l_sub)] = lc_id
        else:
            lc_id = cache_liquid_class[(l_type, l_sub)]
            
        ln_id = get_or_create(cursor,
            "SELECT LiquidID FROM LIQUID_NAME WHERE (LiquidName=%s OR (LiquidName IS NULL AND %s IS NULL)) AND LC_LiquidSubtypeID=%s", (l_name, l_name, lc_id),
            "INSERT INTO LIQUID_NAME (LiquidName, LC_LiquidSubtypeID) VALUES (%s, %s)", (l_name, lc_id)
        )

        # CAUSE
        c_cat = row['Cause Category']
        c_sub = row['Cause Subcategory']
        
        if c_cat not in cache_cause_cat:
            cc_id = get_or_create(cursor, "SELECT CauseCategoryID FROM CAUSE_CATEGORY WHERE CauseCategoryName=%s", (c_cat,), "INSERT INTO CAUSE_CATEGORY (CauseCategoryName) VALUES (%s)", (c_cat,))
            cache_cause_cat[c_cat] = cc_id
        else:
            cc_id = cache_cause_cat[c_cat]
            
        cs_id = get_or_create(cursor,
            "SELECT CauseSubcategoryID FROM CAUSE_SUBCATEGORY WHERE CauseSubcategoryName=%s AND CC_CauseCategoryID=%s", (c_sub, cc_id),
            "INSERT INTO CAUSE_SUBCATEGORY (CauseSubcategoryName, CC_CauseCategoryID) VALUES (%s, %s)", (c_sub, cc_id)
        )

        # PIPELINE
        pf_name = row['Pipeline/Facility Name']
        pf_loc = row['Pipeline Location']
        pf_type = row['Pipeline Type']
        
        cursor.execute("SELECT PiplineFacilityID FROM PIPELINE_FACILITY WHERE (PipelineFacilityName=%s OR (PipelineFacilityName IS NULL AND %s IS NULL)) AND PipelineLocation=%s AND (PipelineType=%s OR (PipelineType IS NULL AND %s IS NULL)) AND OP_OperatorID=%s", (pf_name, pf_name, pf_loc, pf_type, pf_type, op_id))
        res_pf = cursor.fetchone()
        if res_pf:
            pf_id = res_pf[0]
        else:
            cursor.execute("INSERT INTO PIPELINE_FACILITY (PipelineFacilityName, PipelineLocation, PipelineType, OP_OperatorID) VALUES (%s, %s, %s, %s)", (pf_name, pf_loc, pf_type, op_id))
            pf_id = cursor.lastrowid

        # LOCATION
        st_val, cnty_val, city_val = row['Accident State'], row['Accident County'], row['Accident City']
        lat, lng = row['Accident Latitude'], row['Accident Longitude']

        if st_val not in cache_state:
            s_id = get_or_create(cursor, "SELECT StateID FROM STATE WHERE AccidentState=%s", (st_val,), "INSERT INTO STATE (AccidentState) VALUES (%s)", (st_val,))
            cache_state[st_val] = s_id
        else:
            s_id = cache_state[st_val]

        if (cnty_val, s_id) not in cache_county:
            co_id = get_or_create(cursor, "SELECT CountyID FROM COUNTY_TO_STATE WHERE (AccidentCounty=%s OR (AccidentCounty IS NULL AND %s IS NULL)) AND ST_StateID=%s", (cnty_val, cnty_val, s_id), "INSERT INTO COUNTY_TO_STATE (AccidentCounty, ST_StateID) VALUES (%s, %s)", (cnty_val, s_id))
            cache_county[(cnty_val, s_id)] = co_id
        else:
            co_id = cache_county[(cnty_val, s_id)]

        if (city_val, co_id) not in cache_city:
            ci_id = get_or_create(cursor, "SELECT CityID FROM CITY_TO_COUNTY WHERE (AccidentCity=%s OR (AccidentCity IS NULL AND %s IS NULL)) AND COTS_CountyID=%s", (city_val, city_val, co_id), "INSERT INTO CITY_TO_COUNTY (AccidentCity, COTS_CountyID) VALUES (%s, %s)", (city_val, co_id))
            cache_city[(city_val, co_id)] = ci_id
        else:
            ci_id = cache_city[(city_val, co_id)]

        # --- DÜZELTME BURADA ---
        # ACCIDENT_LOCATION: Aynı koordinat varsa HATA VERME, GÖRMEZDEN GEL.
        cursor.execute("INSERT IGNORE INTO ACCIDENT_LOCATION (AccidentLatitude, AccidentLongitude, CTCO_CityID) VALUES (%s, %s, %s)", (lat, lng, ci_id))
            
        # RESULTS & REPORT
        cursor.execute("INSERT INTO ACCIDENT_RESULTS (Liquid_Ignition, Liquid_Explosion, Pipline_Shutdown, Shutdown_DateTime, Restart_DateTime) VALUES (%s, %s, %s, %s, %s)", 
            (row['Liquid Ignition'], row['Liquid Explosion'], row['Pipeline Shutdown'], row['Shutdown Date/Time'], row['Restart Date/Time']))
        ar_result_id = cursor.lastrowid

        cursor.execute("""INSERT INTO ACCIDENT_REPORT (ReportNumber, SupplementalNumber, AccidentDateTime, AL_AccidentLatitude, AL_AccidentLongitude, LN_LiquidID, CS_CauseSubcategoryID, PF_PiplineFacilityID, PF_OP_OperatorID, AR_ResultID) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""", 
            (row['Report Number'], row['Supplemental Number'], row['Accident Date/Time'], lat, lng, ln_id, cs_id, pf_id, op_id, ar_result_id))

        # DETAILS
        for col, c_id in cost_type_ids.items():
            if row[col] > 0: cursor.execute("INSERT INTO ACCIDENT_COSTS (CT_CostTypeID, AR_ResultID, Amount) VALUES (%s, %s, %s)", (c_id, ar_result_id, row[col]))
        for col, s_id in spill_type_ids.items():
            if row[col] > 0: cursor.execute("INSERT INTO ACCIDENT_SPILL_VOLUME (AR_ResultID, ST_SpillTypeID, Barrel) VALUES (%s, %s, %s)", (ar_result_id, s_id, row[col]))
        for col, i_id in impact_type_ids.items():
            if row[col] > 0: cursor.execute("INSERT INTO ACCIDENT_IMPACTS (IT_ImpactTypeID, AR_ResultID, ImpactValue) VALUES (%s, %s, %s)", (i_id, ar_result_id, row[col]))
        
        if index % 100 == 0:
            print(f"{index} satır eklendi...")
            conn.commit()

    conn.commit()
    print("İŞLEM TAMAMLANDI!")

except mysql.connector.Error as err:
    print(f"SQL Hatası: {err}")
finally:
    if 'conn' in locals() and conn.is_connected():
        cursor.close()
        conn.close()